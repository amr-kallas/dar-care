-- Allow providers to read users rows for clients assigned to their own orders.
-- This lets provider order details show real client full name.

begin;

alter table public.users enable row level security;

drop policy if exists "users_select_provider_order_clients" on public.users;
create policy "users_select_provider_order_clients"
  on public.users
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.providers p
      join public.orders o on o.provider_id = p.id
      join public.clients c on c.id = o.client_id
      where p.user_id = auth.uid()
        and c.user_id = users.id
    )
  );

commit;

