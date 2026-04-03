alter table if exists public.users
  add column if not exists fcm_token text,
  add column if not exists fcm_token_updated_at timestamptz;

