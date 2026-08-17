import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import {
  IApiEnvelope,
  IDashboardOverview,
  IDashboardStats,
  IDashboardStatsResponse,
  IMonthlyStatistics,
} from "./type";

const API = {
  getStats: async (): Promise<IDashboardStats> => {
    const { data } = await axios.get<IDashboardStatsResponse>(
      API_ROUTES.DASHBOARD.GET_STATS
    );
    return data.data;
  },

  getOverview: async (): Promise<IDashboardOverview> => {
    const { data } = await axios.get<IApiEnvelope<IDashboardOverview>>(
      API_ROUTES.DASHBOARD.GET_OVERVIEW
    );
    return data.data;
  },

  getMonthlyStatistics: async (year: number): Promise<IMonthlyStatistics> => {
    const { data } = await axios.get<IApiEnvelope<IMonthlyStatistics>>(
      API_ROUTES.DASHBOARD.GET_MONTHLY_STATISTICS,
      { params: { year } }
    );
    return data.data;
  },
};

export default API;
