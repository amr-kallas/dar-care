import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import type { APIList } from "../../types/apiType";
import {
  IAddUser,
  IAdminUser,
  IAdminUsersResponse,
  IAllSubscribtion,
  IGetAdminUsersParams,
  IGetAllUser,
  IGetAllUserParams,
  IGetUser,
} from "./type";

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
  getAll: async (params: IGetAllUserParams) => {
    const { data } = await axios<IGetAllUser>(API_ROUTES.USER.GET_USERS, {
      params: { ...params, PageNumber: params.PageNumber ?? 0,  
       },
    });
    return data;
  },
  getUser: async (TeacherId: string) => {
    const { data } = await axios<IGetUser[]>(API_ROUTES.USER.GET_USER, {
      params: { TeacherId },
    });
    return data;
  },
  getTeachersCount: async () => {
    const { data } = await axios.get(API_ROUTES.USER.GET_USERS_COUNT);
    return data;
  },


  addUser: async (body: IAddUser) => {
    const { data } = await axios.post(API_ROUTES.USER.ADD_USER, body);
    return data;
  },
  deleteAdminUser: async (id: string) => {
    const { data } = await axios.delete(API_ROUTES.ADMIN.DELETE_USER(id));
    return data;
  },
  deleteUser: async (TeacherId: string) => {
    const { data } = await axios.delete(API_ROUTES.USER.Delete_USER, {
      params: { TeacherId },
    });
    return data;
  },

  getAllSubscribtion: async () => {
    const { data } = await axios<IAllSubscribtion[]>(
      API_ROUTES.SETTING.GET_SETTING
    );
    return data;
  },
  addSubscribtion: async (value: number) => {
    const { data } = await axios.put(
      API_ROUTES.SETTING.ADD_SETTING,
      {},
      { params: { value } }
    );
    return data;
  },
};

export default API;
