import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useQuery } from "@tanstack/react-query";
import API from "./api";

export const keys = createQueryKeys("dashboard", {
  getStats: {
    queryFn: () => API.getStats(),
    queryKey: null,
  },
});

export const queries = {
  GetDashboardStats: () => useQuery(keys.getStats),
};
