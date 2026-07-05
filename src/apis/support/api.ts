import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import {
  IGetAllChat,
  IGetAllChatParams,
  IGetAllMessageParams,
  IGetUserMessage,
} from "./type";

const API = {
  getAllChat: async (params: IGetAllChatParams) => {
    const { data } = await axios<IGetAllChat[]>(API_ROUTES.USER.GET_ALL_CHAT, {
      params: { ...params, PageNumber: params.PageNumber ?? 0 },
    });
    return data;
  },

  getChatsUser: async (params: IGetAllMessageParams) => {
    const { data } = await axios<IGetUserMessage[]>(
      API_ROUTES.USER.GET_CHAT_USER,
      {
        params: { ...params, PageNumber: params.PageNumber ?? 0 },
      }
    );
    return data;
  },
};

export default API;
