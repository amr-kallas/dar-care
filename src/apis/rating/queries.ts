import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useQuery } from "@tanstack/react-query";
import API from "./api";
import { IGetAdminRatingsParams } from "./type";

export const keys = createQueryKeys("rating", {
  getAdminRatings: (params: IGetAdminRatingsParams) => ({
    queryFn: () => API.getAdminRatings(params),
    queryKey: [params],
  }),
});

export const queries = {
  GetAdminRatings: (params: IGetAdminRatingsParams) =>
    useQuery(keys.getAdminRatings(params)),
};
