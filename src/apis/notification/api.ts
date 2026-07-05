import axios from "@lib/axios";
import {
  IGetAllNotification,
  IGetAllNotificationParams,
  ISendNotification,
} from "./type";
import API_ROUTES from "@constants/apiRoutes";

const API = {
  getAll: async (params: IGetAllNotificationParams) => {
    const { data } = await axios<IGetAllNotification>(
      API_ROUTES.NOTIFICATION.GET_ALL,
      {
        params: { ...params, PageNumber: params.PageNumber ?? 0 },
      }
    );
    return data;
  },
  sendNotification: async (body: ISendNotification) => {
    const { data } = await axios.post(
      API_ROUTES.NOTIFICATION.SEND_NOTIFICATION,
      body
    );
    return data;
  },
  deleteNotification: async (Id: string) => {
    const { data } = await axios.delete(
      API_ROUTES.NOTIFICATION.REMOVE_NOTIFICATION,
      {
        params: { Id },
      }
    );
    return data;
  },
};

export default API;
