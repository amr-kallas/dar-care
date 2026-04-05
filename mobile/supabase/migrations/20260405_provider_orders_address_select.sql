-- Allow providers to read client addresses that are linked to their own orders.
-- This keeps address visibility scoped to active provider-order relationships.

begin;

alter table public.addresses enable row level security;

drop policy if exists "addresses_select_provider_order_link" on public.addresses;
create policy "addresses_select_provider_order_link"
  on public.addresses
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.providers p
      join public.orders o on o.provider_id = p.id
      where p.user_id = auth.uid()
        and o.address_id = addresses.id
    )
  );

commit;

