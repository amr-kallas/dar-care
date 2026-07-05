import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import { ILoginReq , ILoginRes } from "./type";

const API = {
  login: async (body: ILoginReq) => {
    const { data } = await axios.post<ILoginRes>(API_ROUTES.AUTH.LOGIN, body);
    return data;
  },
};
export default API;