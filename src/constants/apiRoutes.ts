let API_ROUTES = {
  AUTH: {
    root: "v1/auth",
    LOGIN: "admin/login",
  },
  NOTIFICATION: {
    root: "Notification",
    GET_ALL: "GetAllNotificationsCp",
    SEND_NOTIFICATION: "SendNotificationCp",
    REMOVE_NOTIFICATION: "RemoveNotification",
  },
  ADMIN: {
    root: "v1",
    GET_USERS: "admin/users",
    DELETE_USER: (id: string) => `admin/users/${id}`,
    GET_PROVIDERS: "admin/providers",
    DELETE_PROVIDER: (id: string) => `admin/providers/${id}`,
    UPDATE_PROVIDER_STATUS: (id: string) => `admin/providers/${id}/status`,
    UPDATE_PROVIDER_VERIFICATION: (id: string) =>
      `admin/providers/${id}/verification-status`,
    GET_CATEGORIES: "admin/categories",
    UPDATE_CATEGORY: (id: string) => `admin/categories/${id}`,
    DELETE_CATEGORY: (id: string) => `admin/categories/${id}`,
    GET_RATINGS: "admin/ratings",
    GET_SERVICE_REQUESTS: "admin/service-requests",
    GET_NOTIFICATIONS: "notifications",
    SEND_BULK_NOTIFICATION: "admin/notifications/send-bulk",
  },
  CHAT: {
    root: "v1",
    // Admin-only: auth:sanctum + admin middleware.
    GET_CONVERSATIONS: "admin/chat/conversations",
    GET_CONVERSATION: (id: number) => `admin/chat/conversations/${id}`,
    GET_MESSAGES: (id: number) => `admin/chat/conversations/${id}/messages`,
    SEND_MESSAGE: (id: number) => `admin/chat/conversations/${id}/messages`,
    CLOSE_CONVERSATION: (id: number) => `admin/chat/conversations/${id}/close`,
    REOPEN_CONVERSATION: (id: number) =>
      `admin/chat/conversations/${id}/reopen`,
    // Shared actor endpoints (not admin-prefixed).
    MARK_READ: (id: number) => `chat/conversations/${id}/read`,
  },
  DASHBOARD: {
    root: "v1/admin",
    GET_STATS: "dashboard/stats",
    GET_OVERVIEW: "dashboard/overview",
    GET_MONTHLY_STATISTICS: "dashboard/request-statistics/monthly",
  },
};
const controllersArr = Object.entries(API_ROUTES).map(
  ([controllerKey, { root, ...routes }]) => {
    const routesArr = Object.entries(routes);
    const routesPrefixed = Object.fromEntries(
      routesArr.map(([routeKey, route]) => {
        if (typeof route === "function") {
          return [
            routeKey,
            (...params: any[]) => `${root}/${(route as Function)(params[0])}`,
          ];
        }
        return [routeKey, `${root}/${route}`];
      })
    );
    return [controllerKey, { ...routesPrefixed, root }];
  }
);
API_ROUTES = Object.fromEntries(controllersArr) as typeof API_ROUTES;

export default API_ROUTES;
