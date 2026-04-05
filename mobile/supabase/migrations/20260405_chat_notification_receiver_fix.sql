-- Fix chat notification receiver mapping.
-- notifications.user_id must reference public.users.id (auth user id),
-- not profile ids from chats.client_id/chats.provider_id.

begin;

create or replace function public.handle_message_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_client_user_id uuid;
  v_provider_user_id uuid;
  v_receiver_user_id uuid;
  v_sender_name text;
begin
  -- Resolve auth user ids for both chat participants.
  select c.user_id, p.user_id
    into v_client_user_id, v_provider_user_id
  from public.chats ch
  left join public.clients c on c.id = ch.client_id
  left join public.providers p on p.id = ch.provider_id
  where ch.id = new.chat_id;

  if v_client_user_id is null and v_provider_user_id is null then
    return new;
  end if;

  -- Sender is messages.sender_id (auth user id). Receiver is the opposite participant.
  if new.sender_id = v_client_user_id then
    v_receiver_user_id := v_provider_user_id;
  elsif new.sender_id = v_provider_user_id then
    v_receiver_user_id := v_client_user_id;
  else
    -- Sender does not match chat participants; skip notification.
    return new;
  end if;

  if v_receiver_user_id is null then
    return new;
  end if;

  select u.full_name
    into v_sender_name
  from public.users u
  where u.id = new.sender_id;

  insert into public.notifications (
    user_id,
    sender_id,
    chat_id,
    type,
    title,
    body,
    is_read,
    data
  ) values (
    v_receiver_user_id,
    new.sender_id,
    new.chat_id,
    'chat',
    coalesce(v_sender_name, 'New message'),
    new.message,
    false,
    '{}'::jsonb
  );

  return new;
end;
$$;

-- Remove legacy non-internal AFTER INSERT row triggers on messages
-- to avoid duplicate/incorrect notification logic.
do $$
declare
  r record;
begin
  for r in
    select tgname
    from pg_trigger
    where tgrelid = 'public.messages'::regclass
      and not tgisinternal
      and (tgtype & 4) = 4 -- row-level
      and (tgtype & 2) = 2 -- after
      and (tgtype & 1) = 1 -- insert
  loop
    execute format('drop trigger if exists %I on public.messages', r.tgname);
  end loop;
end;
$$;

create trigger trg_messages_after_insert_notification
after insert on public.messages
for each row
execute function public.handle_message_notification();

commit;

