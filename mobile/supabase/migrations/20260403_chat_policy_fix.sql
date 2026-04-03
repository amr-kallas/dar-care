-- Fix chat RLS insert failures for provider/client chat creation.
-- The previous insert policy depended on reading the other participant table row,
-- which can fail when that table has restrictive RLS.

begin;

alter table public.chats enable row level security;
alter table public.messages enable row level security;

-- Remove legacy UI-created policies to avoid overlap/confusion.
drop policy if exists "Users can see their own chats" on public.chats;
drop policy if exists "Users can start a chat" on public.chats;
drop policy if exists "Users can send messages to their chats" on public.messages;
drop policy if exists "Users can view messages in their chats" on public.messages;

-- Recreate canonical chat policies.
drop policy if exists "chats_select_participants" on public.chats;
create policy "chats_select_participants"
  on public.chats
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.clients c
      where c.id = chats.client_id
        and c.user_id = auth.uid()
    )
    or exists (
      select 1
      from public.providers p
      where p.id = chats.provider_id
        and p.user_id = auth.uid()
    )
  );

drop policy if exists "chats_insert_participants" on public.chats;
create policy "chats_insert_participants"
  on public.chats
  for insert
  to authenticated
  with check (
    -- Client can start chat for their own client profile.
    exists (
      select 1
      from public.clients c
      where c.id = chats.client_id
        and c.user_id = auth.uid()
    )
    or
    -- Provider can start chat for their own provider profile.
    exists (
      select 1
      from public.providers p
      where p.id = chats.provider_id
        and p.user_id = auth.uid()
    )
  );

-- Recreate canonical message policies.
drop policy if exists "messages_select_participants" on public.messages;
create policy "messages_select_participants"
  on public.messages
  for select
  to authenticated
  using (
    exists (
      select 1
      from public.chats ch
      left join public.clients c on c.id = ch.client_id
      left join public.providers p on p.id = ch.provider_id
      where ch.id = messages.chat_id
        and (c.user_id = auth.uid() or p.user_id = auth.uid())
    )
  );

drop policy if exists "messages_insert_participants" on public.messages;
create policy "messages_insert_participants"
  on public.messages
  for insert
  to authenticated
  with check (
    sender_id = auth.uid()
    and exists (
      select 1
      from public.chats ch
      left join public.clients c on c.id = ch.client_id
      left join public.providers p on p.id = ch.provider_id
      where ch.id = messages.chat_id
        and (c.user_id = auth.uid() or p.user_id = auth.uid())
    )
  );

commit;

