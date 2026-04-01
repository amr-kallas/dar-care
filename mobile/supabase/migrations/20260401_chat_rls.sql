-- Chat RLS policies for participant-safe access
-- Apply via Supabase migration workflow.

begin;

alter table public.chats enable row level security;
alter table public.messages enable row level security;

create index if not exists idx_chats_client_provider
  on public.chats(client_id, provider_id);

create index if not exists idx_messages_chat_id_created_at
  on public.messages(chat_id, created_at);

-- A user can read chats where they are either the client or provider owner.
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

-- A participant can create a chat for their own profile side.
drop policy if exists "chats_insert_participants" on public.chats;
create policy "chats_insert_participants"
  on public.chats
  for insert
  to authenticated
  with check (
    (
      exists (
        select 1
        from public.clients c
        where c.id = chats.client_id
          and c.user_id = auth.uid()
      )
      and exists (
        select 1
        from public.providers p
        where p.id = chats.provider_id
      )
    )
    or
    (
      exists (
        select 1
        from public.providers p
        where p.id = chats.provider_id
          and p.user_id = auth.uid()
      )
      and exists (
        select 1
        from public.clients c
        where c.id = chats.client_id
      )
    )
  );

-- A user can read messages only from chats they participate in.
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

-- A participant can send a message only as themselves.
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

