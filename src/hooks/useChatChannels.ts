import { useEffect, useRef } from "react";
import { getEcho } from "@lib/echo";
import { getAdminId } from "@lib/session";
import type {
  IMessageSentEvent,
  INotificationCreatedEvent,
} from "@apis/chat/type";

/**
 * Keeps the latest callback in a ref so subscriptions are not torn down and
 * rebuilt on every render just because an inline handler changed identity.
 */
const useLatest = <T>(value: T) => {
  const ref = useRef(value);
  ref.current = value;
  return ref;
};

/**
 * Subscribes to `private-conversation.{id}` for `.MessageSent`.
 *
 * Only `.MessageSent` is listened for: `.MessageRead` and `.ConversationUpdated`
 * exist as classes but the backend never dispatches them today, so close/reopen
 * and read state have to come from REST responses.
 */
export const useConversationChannel = (
  conversationId: number | null,
  onMessage: (event: IMessageSentEvent) => void
) => {
  const handler = useLatest(onMessage);

  useEffect(() => {
    if (!conversationId) return;
    const echo = getEcho();
    if (!echo) return;

    const name = `conversation.${conversationId}`;
    const channel = echo.private(name);
    const listener = (event: IMessageSentEvent) => handler.current(event);
    channel.listen(".MessageSent", listener);

    return () => {
      channel.stopListening(".MessageSent", listener);
      echo.leave(name);
    };
  }, [conversationId, handler]);
};

/**
 * Subscribes to the admin's own inbox channel, `private-user.user.{adminId}`.
 *
 * Admins are not conversation participants, so participant-based unread math
 * stays near zero for them — these events are the reliable signal that a new
 * support message landed.
 */
export const useAdminInboxChannel = (
  onNotification: (event: INotificationCreatedEvent) => void
) => {
  const handler = useLatest(onNotification);

  useEffect(() => {
    const adminId = getAdminId();
    if (!adminId) return;
    const echo = getEcho();
    if (!echo) return;

    const name = `user.user.${adminId}`;
    const channel = echo.private(name);
    const created = (event: INotificationCreatedEvent) =>
      handler.current(event);
    const unread = () => handler.current({} as INotificationCreatedEvent);

    channel.listen(".NotificationCreated", created);
    channel.listen(".UnreadCountUpdated", unread);

    return () => {
      channel.stopListening(".NotificationCreated", created);
      channel.stopListening(".UnreadCountUpdated", unread);
      echo.leave(name);
    };
  }, [handler]);
};

/**
 * Runs `onReconnect` when Pusher recovers the connection. There is no
 * "messages since id" endpoint, so callers refetch and dedupe instead.
 */
export const usePusherReconnect = (onReconnect: () => void) => {
  const handler = useLatest(onReconnect);

  useEffect(() => {
    const echo = getEcho();
    if (!echo) return;

    const connection = echo.connector.pusher.connection;
    let wasDisconnected = false;

    const onState = (states: { previous: string; current: string }) => {
      if (states.current !== "connected") {
        wasDisconnected = true;
        return;
      }
      if (wasDisconnected) {
        wasDisconnected = false;
        handler.current();
      }
    };

    connection.bind("state_change", onState);
    return () => connection.unbind("state_change", onState);
  }, [handler]);
};
