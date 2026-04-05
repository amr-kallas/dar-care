-- Keep auth signup resilient even when user metadata is malformed.
begin;

create or replace function public.handle_auth_user_created()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_meta jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  v_full_name text;
  v_phone text;
  v_role text;
begin
  v_full_name := nullif(trim(v_meta ->> 'full_name'), '');
  if v_full_name is null then
    v_full_name := split_part(coalesce(new.email, 'user@example.com'), '@', 1);
  end if;

  -- Store only digits to avoid downstream casting/validation errors.
  v_phone := nullif(regexp_replace(coalesce(v_meta ->> 'phone', ''), '[^0-9]', '', 'g'), '');

  v_role := lower(coalesce(nullif(trim(v_meta ->> 'role'), ''), 'client'));
  if v_role not in ('client', 'provider') then
    v_role := 'client';
  end if;

  begin
    insert into public.users (id, email, full_name, phone, role, created_at)
    values (
      new.id,
      new.email,
      v_full_name,
      v_phone,
      v_role,
      coalesce(new.created_at, now())
    )
    on conflict (id) do update
    set email = excluded.email,
        full_name = coalesce(excluded.full_name, public.users.full_name),
        phone = coalesce(excluded.phone, public.users.phone),
        role = coalesce(excluded.role, public.users.role);
  exception when others then
    -- Do not block auth account creation because of profile sync issues.
    raise warning 'handle_auth_user_created failed for user %: %', new.id, sqlerrm;
  end;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_auth_user_created();

commit;

