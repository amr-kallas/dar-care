import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useQuery } from "@tanstack/react-query";
import API from "./api";

export const keys = createQueryKeys("dashboard", {
  getStats: {
    queryFn: () => API.getStats(),
    queryKey: null,
  },
  getOverview: {
    queryFn: () => API.getOverview(),
    queryKey: null,
  },
  getMonthlyStatistics: (year: number) => ({
    queryFn: () => API.getMonthlyStatistics(year),
    queryKey: [year],
  }),
});

export const queries = {
  GetDashboardStats: () => useQuery(keys.getStats),
  GetDashboardOverview: () => useQuery(keys.getOverview),
  GetMonthlyStatistics: (year: number) =>
    useQuery(keys.getMonthlyStatistics(year)),
};
