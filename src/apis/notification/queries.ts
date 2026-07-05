import { createQueryKeys } from "@lukemorales/query-key-factory";
import { IGetAllNotification, IGetAllNotificationParams } from "./type";
import API from "./api";
import { APIList } from "../../types/apiType";
import { useInfiniteQuery, useMutation } from "@tanstack/react-query";

export const keys = createQueryKeys("user", {
  getAllNotification: (params: IGetAllNotificationParams) => ({
    queryFn: () => API.getAll(params),
    queryKey: [params],
  }),
});

export const queries = {
  GetAllNotification: (params: IGetAllNotificationParams) =>
    useInfiniteQuery<
      APIList<IGetAllNotificationParams>,
      Error,
      IGetAllNotification
    >({
      queryKey: [params],
      queryFn: ({ pageParam = 0 }) => {
        return API.getAll({
          ...params,
          PageNumber: pageParam as number,
        });
      },

      getNextPageParam: (lastPage) => {
        const currentPage = lastPage.pageNumber;
        const totalPages = lastPage.totalPages;

        return currentPage < totalPages - 1 ? currentPage + 1 : undefined;
      },
      getPreviousPageParam: (firstPage) => {
        const currentPage = firstPage.pageNumber;
        return currentPage > 0 ? currentPage - 1 : undefined;
      },
    }),
  SendNotification: () => useMutation({ mutationFn: API.sendNotification }),
  DeleteNotification: () => useMutation({ mutationFn: API.deleteNotification }),
};
