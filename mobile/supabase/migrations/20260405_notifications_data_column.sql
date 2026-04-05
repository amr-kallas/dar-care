-- Ensure notifications table supports optional JSON payload metadata used by chat push.
-- This fixes runtime failures where functions/selects reference notifications.data.

begin;

alter table public.notifications
  add column if not exists data jsonb;

update public.notifications
set data = '{}'::jsonb
where data is null;

alter table public.notifications
  alter column data set default '{}'::jsonb;

commit;

