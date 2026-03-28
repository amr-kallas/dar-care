-- Location onboarding support for Dar Care
-- Safe to run in Supabase SQL editor.

begin;

-- Optional metadata for freshness checks.
alter table public.addresses
  add column if not exists location_updated_at timestamptz not null default now();

-- Keep coordinates valid.
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'addresses_current_lat_range_check'
  ) then
    alter table public.addresses
      add constraint addresses_current_lat_range_check
      check (current_lat is null or (current_lat >= -90 and current_lat <= 90));
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conname = 'addresses_current_lang_range_check'
  ) then
    alter table public.addresses
      add constraint addresses_current_lang_range_check
      check (current_lang is null or (current_lang >= -180 and current_lang <= 180));
  end if;
end
$$;

create index if not exists idx_clients_user_id on public.clients(user_id);
create index if not exists idx_providers_user_id on public.providers(user_id);

-- RLS helpers for location writes to addresses owned by the user.
alter table public.addresses enable row level security;

-- Select own addresses
 drop policy if exists "addresses_select_own" on public.addresses;
create policy "addresses_select_own"
  on public.addresses
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.clients c
      where c.user_id = auth.uid()
        and c.id = addresses.client_id
    )
    or exists (
      select 1
      from public.providers p
      where p.user_id = auth.uid()
        and p.id = addresses.provider_id
    )
  );

-- Insert own addresses
 drop policy if exists "addresses_insert_own" on public.addresses;
create policy "addresses_insert_own"
  on public.addresses
  for insert
  to authenticated
  with check (
    (client_id is not null and exists (
      select 1
      from public.clients c
      where c.user_id = auth.uid() and c.id = addresses.client_id
    ))
    or
    (provider_id is not null and exists (
      select 1
      from public.providers p
      where p.user_id = auth.uid() and p.id = addresses.provider_id
    ))
  );

-- Update own addresses
 drop policy if exists "addresses_update_own" on public.addresses;
create policy "addresses_update_own"
  on public.addresses
  for update
  to authenticated
  using (
    exists (
      select 1
      from public.clients c
      where c.user_id = auth.uid()
        and c.id = addresses.client_id
    )
    or exists (
      select 1
      from public.providers p
      where p.user_id = auth.uid()
        and p.id = addresses.provider_id
    )
  )
  with check (
    exists (
      select 1
      from public.clients c
      where c.user_id = auth.uid()
        and c.id = addresses.client_id
    )
    or exists (
      select 1
      from public.providers p
      where p.user_id = auth.uid()
        and p.id = addresses.provider_id
    )
  );

commit;

