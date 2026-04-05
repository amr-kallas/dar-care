-- Ensure providers can read client profiles linked to their own orders.
-- Needed to resolve client -> user_id -> users.full_name in provider order details.

begin;

alter table public.clients enable row level security;

drop policy if exists "clients_select_provider_order_link" on public.clients;
create policy "clients_select_provider_order_link"
  on public.clients
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.providers p
      join public.orders o on o.provider_id = p.id
      where p.user_id = auth.uid()
        and o.client_id = clients.id
    )
  );

commit;

