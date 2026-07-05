import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import type { APIList } from "../../types/apiType";
import {
  IAdminServiceRequest,
  IAdminServiceRequestsResponse,
  IGetAdminServiceRequestsParams,
} from "./type";

const API = {
  getAdminServiceRequests: async (
    params: IGetAdminServiceRequestsParams
  ): Promise<APIList<IAdminServiceRequest>> => {
    const { data } = await axios.get<IAdminServiceRequestsResponse>(
      API_ROUTES.ADMIN.GET_SERVICE_REQUESTS,
      {
        params: {
          status: params.status ?? "",
          urgency: params.urgency ?? "",
          page: (params.page ?? 0) + 1,
          per_page: params.per_page ?? 10,
        },
      }
    );

    const paginated = data.data;

    return {
      pageNumber: paginated.current_page - 1,
      totalPages: paginated.last_page,
      totalDataCount: paginated.total,
      data: paginated.data,
    };
  },
};

export default API;
