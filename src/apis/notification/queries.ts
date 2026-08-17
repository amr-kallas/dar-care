import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useMutation, useQuery } from "@tanstack/react-query";
import API from "./api";

export const keys = createQueryKeys("notification", {
  getNotifications: {
    queryFn: () => API.getNotifications(),
    queryKey: null,
  },
});

export const queries = {
  GetNotifications: () => useQuery(keys.getNotifications),
  SendBulkNotification: () =>
    useMutation({ mutationFn: API.sendBulkNotification }),
};
