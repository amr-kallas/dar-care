import ax from "axios";
// const BACKEND_BASE_URL = "http://3.223.131.190:96";
const BACKEND_BASE_URL = "http://127.0.0.1:8000";
// const BACKEND_BASE_URL = "http://testapi.butterfly-flight.com"
// const BACKEND_BASE_URL = "http://api.butterfly-flight.com"
// export const BACKEND_REALTIME_URL = "ws://3.223.131.190:96";
export const BACKEND_REALTIME_URL = "ws://testapi.butterfly-flight.com";
// export const BACKEND_REALTIME_URL = "ws://api.butterfly-flight.com";
const API_BASE_URL = BACKEND_BASE_URL + "/api";
const axios = ax.create({
  baseURL: API_BASE_URL,
});
axios.interceptors.request.use(
  (config) => {
    config.headers.Authorization = `Bearer ${localStorage.getItem("token")}`;

    return config;
  },
  (error) => {
    Promise.reject(error);
  }
);

axios.interceptors.response.use(
  (response) => response,
  async (errors) => {
    if (errors?.response.status == 401) {
      localStorage.clear();
      window.location.href = `login`;
    }
    return Promise.reject(errors);
  }
);

export default axios;
