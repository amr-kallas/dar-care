import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import {
  INotification,
  INotificationsResponse,
  ISendBulkNotification,
  ISendBulkNotificationResponse,
} from "./type";

const API = {
  getNotifications: async (): Promise<INotification[]> => {
    const { data } = await axios.get<INotificationsResponse>(
      API_ROUTES.ADMIN.GET_NOTIFICATIONS
    );
    const payload = data.data;
    return Array.isArray(payload) ? payload : payload?.data ?? [];
  },
  sendBulkNotification: async (body: ISendBulkNotification) => {
    const { data } = await axios.post<ISendBulkNotificationResponse>(
      API_ROUTES.ADMIN.SEND_BULK_NOTIFICATION,
      body
    );
    return data;
  },
};

export default API;
