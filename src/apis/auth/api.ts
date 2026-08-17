import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import { ILoginReq, ILoginRes } from "./type";

function extractToken(res: ILoginRes): string | undefined {
  return (
    res.data?.token ??
    res.data?.access_token ??
    res.token ??
    res.access_token
  );
}

const API = {
  login: async (body: ILoginReq) => {
    const { data } = await axios.post<ILoginRes>(API_ROUTES.AUTH.LOGIN, body);
    const token = extractToken(data);

    if (!token) {
      throw new Error(data.message ?? "لم يتم استلام رمز الدخول من الخادم");
    }

    return {
      ...data,
      token,
      user: data.data?.admin ?? data.data?.user ?? data.user,
    };
  },
};

export default API;
