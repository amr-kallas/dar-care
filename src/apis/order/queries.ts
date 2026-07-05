import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useQuery } from "@tanstack/react-query";
import API from "./api";
import { IGetAdminServiceRequestsParams } from "./type";

export const keys = createQueryKeys("order", {
  getAdminServiceRequests: (params: IGetAdminServiceRequestsParams) => ({
    queryFn: () => API.getAdminServiceRequests(params),
    queryKey: [params],
  }),
});

export const queries = {
  GetAdminServiceRequests: (params: IGetAdminServiceRequestsParams) =>
    useQuery(keys.getAdminServiceRequests(params)),
};
