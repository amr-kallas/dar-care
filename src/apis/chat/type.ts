/**
 * Shapes mirror the Laravel resources in app/Modules/Chat/Http/Resources.
 * Do not add fields the backend does not send (attachments, typing, assignment).
 */

export type MorphActorType = "user" | "provider";
export type DisplayRole = "customer" | "artisan" | "support";
export type ConversationType =
  | "request"
  | "support_customer"
  | "support_provider";
export type ConversationStatus = "open" | "closed" | "read_only";

export type IApiEnvelope<T> = {
  success: boolean;
  message: string;
  data: T;
  errors: unknown;
};

export type ICursorPage<T> = {
  data: T[];
  next_cursor: string | null;
  prev_cursor?: string | null;
  has_more: boolean;
};

export type IMessageSender = {
  type: MorphActorType | string;
  id: number;
  display_role: DisplayRole | string;
};

export type IChatMessage = {
  id: number;
  conversation_id: number;
  service_request_id: number | null;
  client_message_id: string | null;
  type: string;
  body: string | null;
  deleted: boolean;
  sender: IMessageSender;
  reply_to_message_id: number | null;
  created_at: string | null;
};

export type IConversationParticipant = {
  type: MorphActorType | string;
  id: number;
  display_role: DisplayRole | string;
  name: string | null;
  joined_at: string | null;
  left_at: string | null;
  muted: boolean;
  last_read_at: string | null;
};

export type IServiceRequestSummary = {
  id: number;
  status: string;
  urgency: string | null;
  description: string;
  provider_id: number | null;
  user_id: number;
};

export type IConversation = {
  id: number;
  type: ConversationType | string;
  status: ConversationStatus | string;
  service_request?: IServiceRequestSummary;
  participants: IConversationParticipant[];
  last_message?: IChatMessage;
  last_message_at: string | null;
  unread_count: number;
  muted: boolean;
  closed_at: string | null;
  created_at: string | null;
};

export type IGetConversationsParams = Partial<{
  type: ConversationType | "";
  status: ConversationStatus | "";
  service_request: number;
  customer: number;
  provider: number;
  search: string;
  cursor: string;
}>;

export type ISendMessageBody = {
  body: string;
  client_message_id?: string;
  reply_to_message_id?: number;
};

/** Local-only send state; never returned by the API. */
export type MessageStatus = "pending" | "sent" | "failed";

export type IChatMessageView = IChatMessage & {
  /** Absent for messages that came straight from the server. */
  status?: MessageStatus;
};

/** `.MessageSent` broadcast payload — a subset of the REST message resource. */
export type IMessageSentEvent = {
  id: number;
  client_message_id: string | null;
  conversation_id: number;
  sender: IMessageSender;
  type: string;
  body: string | null;
  reply_to: number | null;
  created_at: string | null;
};

export type INotificationCreatedEvent = {
  notification: {
    id: string;
    type: string;
    title: string | null;
    body: string | null;
    conversation_id: number | null;
    message_id: number | null;
    service_request_id: number | null;
    route: string | null;
    read_at: string | null;
    is_read: boolean;
    created_at: string;
  };
};
