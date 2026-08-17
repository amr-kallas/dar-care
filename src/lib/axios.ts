import ax from "axios";
import API_ROUTES from "@constants/apiRoutes";
import { BACKEND_BASE_URL } from "@constants/env";
import { disconnectEcho } from "./echo";
import { clearSession, getToken } from "./session";

const LOGIN_PATH = API_ROUTES.AUTH.LOGIN;
const API_BASE_URL = BACKEND_BASE_URL + "/api";

const axios = ax.create({
  baseURL: API_BASE_URL,
  headers: {
    Accept: "application/json",
  },
});

axios.interceptors.request.use(
  (config) => {
    const token = getToken();
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }

    return config;
  },
  (error) => Promise.reject(error)
);

axios.interceptors.response.use(
  (response) => response,
  async (errors) => {
    const isLoginRequest = errors?.config?.url?.includes(LOGIN_PATH);
    if (errors?.response?.status == 401 && !isLoginRequest) {
      // Drop the realtime socket too, otherwise it keeps retrying channel auth
      // with a token the server has already rejected.
      disconnectEcho();
      clearSession();
      window.location.href = `login`;
    }
    return Promise.reject(errors);
  }
);

export default axios;
