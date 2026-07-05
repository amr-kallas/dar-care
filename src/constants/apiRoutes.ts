let API_ROUTES = {
  AUTH: {
    root: "CpAccount",
    LOGIN: "Login",
  },
  USER: {
    root: "CpTeacher",
    GET_USERS: "GetAllTeachers",
    GET_USER: "GetScanReccords",
    ADD_USER: "AddTeacher",
    Delete_USER: "DeleteTeacher",
    GET_CHAT_USER: "GetAllChatsTeacher",
    GET_ALL_CHAT: "GetChatsCp",
    GET_USERS_COUNT: "GetTeachersCount",
  },
  NOTIFICATION: {
    root: "Notification",
    GET_ALL: "GetAllNotificationsCp",
    SEND_NOTIFICATION: "SendNotificationCp",
    REMOVE_NOTIFICATION: "RemoveNotification",
  },
  SETTING: {
    root: "Setting",
    GET_SETTING: "GetAllSettings",
    ADD_SETTING: "UpdateSetting",
  },
  QUESTIONS_GENERATOR: {
    root: "QuestionsGenerator",
    UPLOAD_FILE: "UploadFile",
    GET_ALL_BOOKS: "GetAllBooks",
    GET_BOOK_DETAILS: "GetBookDetails",
    UPDATE_BOOK: "UpdateBook",
    REMOVE_BOOK: "RemoveBook",
    GENERATE_QUESTIONS: "GenerateQuestions",
    GET_ALL_QUESTIONS: "GetAllQuestions",
    GET_QUESTION_DETAILS: "GetQuestionDetails",
    UPDATE_QUESTION: "UpdateQuestion",
    REMOVE_QUESTION: "RemoveQuestion",
    GENERATE_EXAM: "GenerateExam",
  },
  CLASS: {
    root: "Class",
    GET_ALL_CLASS: "GetAllClass",
    GET_CLASS: 'GetClass',
    SET_CLASS:'SetClass'
  },
  ADMIN: {
    root: "v1",
    GET_USERS: "admin/users",
    DELETE_USER: (id: string) => `admin/users/${id}`,
    GET_PROVIDERS: "admin/providers",
    DELETE_PROVIDER: (id: string) => `admin/providers/${id}`,
    UPDATE_PROVIDER_STATUS: (id: string) => `admin/providers/${id}/status`,
    GET_CATEGORIES: "admin/categories",
    UPDATE_CATEGORY: (id: string) => `admin/categories/${id}`,
    DELETE_CATEGORY: (id: string) => `admin/categories/${id}`,
    GET_RATINGS: "admin/ratings",
    GET_SERVICE_REQUESTS: "admin/service-requests",
  },
  DASHBOARD: {
    root: "admin",
    GET_STATS: "dashboard/stats",
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
