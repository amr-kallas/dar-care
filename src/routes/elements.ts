import { lazy } from "react";
export const HOME_PAGES = {
  HOME : lazy(() => import("../pages/home/home")),
};
export const NOTIFICATION_PAGES = {
    NOTIFICATION : lazy(() => import("../pages/notification/notification")),
  };

  export const USERS_PAGES = {
    USER : lazy(() => import("../pages/users/usersPage")),
  };

  export const CRAFTSMEN_PAGES = {
    CRAFTSMEN: lazy(() => import("../pages/users/craftsmenPage")),
  };

  export const SUPPORT_PAGES = {
    SUPPORT: lazy(() => import("../pages/support/support")),
    MESSAGES: lazy(() => import("../pages/support/messages")),
};
  
export const BOOKS_PAGES = {
    BOOKS:lazy(()=>import('../pages/Books/Books')),
  QUES: lazy(() => import("../pages/Questions/Ques")),
  }
export const QUES_PAGES = {
  QUES: lazy(() => import("../pages/Questions/Ques")),
};

export const ORDERS_PAGES = {
  ORDERS: lazy(() => import("../pages/orders/orders")),
};

export const SERVICE_CATEGORIES_PAGES = {
  SERVICE_CATEGORIES: lazy(
    () => import("../pages/serviceCategories/serviceCategories")
  ),
};

export const REVIEWS_PAGES = {
  REVIEWS: lazy(() => import("../pages/reviews/reviews")),
};