import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import { IDashboardStats, IDashboardStatsResponse } from "./type";

const API = {
  getStats: async (): Promise<IDashboardStats> => {
    const { data } = await axios.get<IDashboardStatsResponse>(
      API_ROUTES.DASHBOARD.GET_STATS
    );
    return data.data;
  },
};

export default API;
