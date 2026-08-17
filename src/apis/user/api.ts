import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import type { APIList } from "../../types/apiType";
import { IAdminUser, IAdminUsersResponse, IGetAdminUsersParams } from "./type";

const API = {
  getAdminUsers: async (
    params: IGetAdminUsersParams
  ): Promise<APIList<IAdminUser>> => {
    const { data } = await axios.get<IAdminUsersResponse>(
      API_ROUTES.ADMIN.GET_USERS,
      {
        params: {
          search: params.search ?? "",
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

  deleteAdminUser: async (id: string) => {
    const { data } = await axios.delete(API_ROUTES.ADMIN.DELETE_USER(id));
    return data;
  },
};

export default API;
