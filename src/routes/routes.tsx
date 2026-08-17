import {
  Route,
  createBrowserRouter,
  createRoutesFromElements,
} from "react-router-dom";
import SomethingWentWrong from "../components/feedbacks/somethingWentWrong";
import { lazy } from "react";
import { LoginPage } from "@pages/auth/login";
import NotAuth from "@components/routes/NotAuth";
import Auth from "@components/routes/Auth";
import {
  AUTH_PATH,
  CRAFTSMEN_PATH,
  NOTIFICATION_PATH,
  ORDERS_PATH,
  REVIEWS_PATH,
  SERVICE_CATEGORIES_PATH,
  SUPPORT_PATH,
  USER_PATH,
} from "./path";
import {
  CRAFTSMEN_PAGES,
  HOME_PAGES,
  NOTIFICATION_PAGES,
  ORDERS_PAGES,
  REVIEWS_PAGES,
  SERVICE_CATEGORIES_PAGES,
  SUPPORT_PAGES,
  USERS_PAGES,
} from "./elements";
const Layout = lazy(() => import("../pages/layout/layout"));

export default createBrowserRouter(
  createRoutesFromElements(
    <Route path="/">
      {/* <Route element={<NotAuth />}> */}
        <Route path={AUTH_PATH.LOGIN} element={<LoginPage />} />
      {/* </Route> */}
      <Route element={<Auth />}>
        <Route element={<Layout />}>
          {/* home page */}
          <Route path="" element={<HOME_PAGES.HOME />} />
          {/* user page */}
          <Route path={USER_PATH.USER} element={<USERS_PAGES.USER />} />
          <Route
            path={CRAFTSMEN_PATH.CRAFTSMEN}
            element={<CRAFTSMEN_PAGES.CRAFTSMEN />}
          />

          {/* support pages  */}
          <Route
            path={SUPPORT_PATH.SUPPORT}
            element={<SUPPORT_PAGES.SUPPORT />}
          >
            <Route
              path={SUPPORT_PATH.MESSAGES}
              element={<SUPPORT_PAGES.MESSAGES />}
            />
          </Route>

          {/* notification page */}
          <Route
            path={NOTIFICATION_PATH.NOTIFICATION}
            element={<NOTIFICATION_PAGES.NOTIFICATION />}
          />
          <Route
            path={ORDERS_PATH.ORDERS}
            element={<ORDERS_PAGES.ORDERS />}
          />
          <Route
            path={SERVICE_CATEGORIES_PATH.SERVICE_CATEGORIES}
            element={<SERVICE_CATEGORIES_PAGES.SERVICE_CATEGORIES />}
          />
          <Route
            path={REVIEWS_PATH.REVIEWS}
            element={<REVIEWS_PAGES.REVIEWS />}
          />
          <Route path="*" element={<SomethingWentWrong />} />
        </Route>
      </Route>
    </Route>
  )
);
