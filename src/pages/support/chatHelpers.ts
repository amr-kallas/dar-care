import type {
  IChatMessageView,
  IConversation,
  IMessageSentEvent,
} from "@apis/chat/type";

export const CONVERSATION_TYPE_LABEL: Record<string, string> = {
  support_customer: "دعم العملاء",
  support_provider: "دعم الحرفيين",
  request: "محادثة طلب",
};

export const DISPLAY_ROLE_LABEL: Record<string, string> = {
  customer: "عميل",
  artisan: "حرفي",
  support: "الدعم",
};

export const isSupport = (conversation?: IConversation) =>
  conversation?.type === "support_customer" ||
  conversation?.type === "support_provider";

/**
 * Admins may only send in support conversations the backend still marks open —
 * request conversations are inspect-only, and closed/read_only reject sends
 * with 403.
 */
export const canAdminSend = (conversation?: IConversation) =>
  !!conversation && isSupport(conversation) && conversation.status === "open";

/** A message is ours when the admin (a `user` morph) sent it as support. */
export const isOwnMessage = (
  message: IChatMessageView,
  adminId: number | null
) =>
  message.sender.type === "user" &&
  (message.sender.display_role === "support" ||
    (adminId != null && message.sender.id === adminId));

/** Names the human on the other side of a support thread. */
export const counterpartName = (conversation?: IConversation) => {
  if (!conversation) return "";
  const other = conversation.participants?.find(
    (p) => p.display_role !== "support"
  );
  const label = other?.display_role
    ? DISPLAY_ROLE_LABEL[other.display_role] ?? other.display_role
    : "";
  if (other?.name) return other.name;
  return label || CONVERSATION_TYPE_LABEL[conversation.type] || "محادثة";
};

export const formatTime = (iso: string | null) =>
  iso
    ? new Date(iso).toLocaleTimeString("ar-EG", {
        hour: "numeric",
        minute: "2-digit",
      })
    : "";

export const formatDay = (iso: string | null) =>
  iso
    ? new Date(iso).toLocaleDateString("ar-EG", {
        day: "numeric",
        month: "short",
      })
    : "";

/**
 * Mirrors the DB uniqueness constraint
 * (conversation_id, sender_type, sender_id, client_message_id), so an optimistic
 * row and the broadcast that echoes it collapse onto one key.
 */
export const messageKey = (message: IChatMessageView) =>
  message.client_message_id
    ? `cid:${message.sender.type}:${message.sender.id}:${message.client_message_id}`
    : `id:${message.id}`;

/** `.MessageSent` omits a few REST-only fields and renames `reply_to`. */
export const eventToMessage = (event: IMessageSentEvent): IChatMessageView => ({
  id: event.id,
  conversation_id: event.conversation_id,
  service_request_id: null,
  client_message_id: event.client_message_id,
  type: event.type,
  body: event.body,
  deleted: false,
  sender: event.sender,
  reply_to_message_id: event.reply_to,
  created_at: event.created_at,
  status: "sent",
});

/**
 * Server rows win over local ones, so an optimistic bubble is replaced by its
 * persisted twin rather than duplicated.
 */
export const mergeMessages = (
  server: IChatMessageView[],
  local: IChatMessageView[]
) => {
  const map = new Map<string, IChatMessageView>();
  local.forEach((message) => map.set(messageKey(message), message));
  server.forEach((message) => map.set(messageKey(message), message));

  return [...map.values()].sort((a, b) => {
    const at = a.created_at ? Date.parse(a.created_at) : 0;
    const bt = b.created_at ? Date.parse(b.created_at) : 0;
    if (at !== bt) return at - bt;
    return a.id - b.id;
  });
};

export const newClientMessageId = () =>
  typeof crypto !== "undefined" && "randomUUID" in crypto
    ? crypto.randomUUID()
    : `cid-${Date.now()}-${Math.random().toString(16).slice(2)}`;
