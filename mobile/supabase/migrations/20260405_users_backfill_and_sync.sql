-- Backfill missing public.users rows and keep auth/public users in sync.
-- Fixes notification inserts that fail on notifications_user_id_fkey.

begin;

-- 1) Backfill any auth users missing in public.users.
insert into public.users (id, email, full_name, phone, role, created_at)
select
  au.id,
  au.email,
  coalesce(
    nullif(au.raw_user_meta_data ->> 'full_name', ''),
    split_part(coalesce(au.email, 'user@example.com'), '@', 1)
  ) as full_name,
  nullif(au.raw_user_meta_data ->> 'phone', '') as phone,
  case
    when p.id is not null then 'provider'
    when c.id is not null then 'client'
    else coalesce(nullif(au.raw_user_meta_data ->> 'role', ''), 'client')
  end as role,
  coalesce(au.created_at, now()) as created_at
from auth.users au
left join public.providers p on p.user_id = au.id
left join public.clients c on c.user_id = au.id
left join public.users u on u.id = au.id
where u.id is null;

-- 2) Keep public.users auto-created for any future auth signup.
create or replace function public.handle_auth_user_created()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, email, full_name, phone, role, created_at)
  values (
    new.id,
    new.email,
    coalesce(
      nullif(new.raw_user_meta_data ->> 'full_name', ''),
      split_part(coalesce(new.email, 'user@example.com'), '@', 1)
    ),
    nullif(new.raw_user_meta_data ->> 'phone', ''),
    coalesce(nullif(new.raw_user_meta_data ->> 'role', ''), 'client'),
    coalesce(new.created_at, now())
  )
  on conflict (id) do update
  set email = excluded.email,
      full_name = coalesce(excluded.full_name, public.users.full_name),
      phone = coalesce(excluded.phone, public.users.phone),
      role = coalesce(excluded.role, public.users.role);

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_auth_user_created();

commit;
