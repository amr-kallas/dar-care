/**
 * "all"      -> يوصل لكل المستخدمين، وبدون `user_id` أبداً
 * "specific" -> لمستخدم واحد، ولازم يجي معه `user_id`
 */
export type INotificationTarget = "all" | "specific";

export type INotification = {
  id: string;
  type: string;
  title: string;
  body: string;
  data: Record<string, string> | null;
  route: string | null;
  conversation_id: string | null;
  message_id: string | null;
  service_request_id: number | string | null;
  read_at: string | null;
  is_read: boolean;
  created_at: string;
};

export type INotificationsResponse = {
  success: boolean;
  message: string;
  // The endpoint returns a plain array today, but tolerate a Laravel paginator
  // wrapper in case pagination is switched on later.
  data: INotification[] | { data: INotification[] };
  errors: unknown;
};

export type ISendBulkNotification = {
  target: INotificationTarget;
  title: string;
  message: string;
  /** بينبعت بس لما يكون target = "specific" */
  user_id?: number;
};

export type ISendBulkNotificationResponse = {
  success: boolean;
  message: string;
  data: unknown;
  errors: unknown;
};
