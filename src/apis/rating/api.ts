import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import type { APIList } from "../../types/apiType";
import {
  IAdminRating,
  IAdminRatingsResponse,
  IGetAdminRatingsParams,
} from "./type";

const API = {
  getAdminRatings: async (
    params: IGetAdminRatingsParams
  ): Promise<APIList<IAdminRating>> => {
    const { data } = await axios.get<IAdminRatingsResponse>(
      API_ROUTES.ADMIN.GET_RATINGS,
      {
        params: {
          rating: params.rating ?? "",
          provider_id: params.provider_id ?? "",
          page: (params.page ?? 0) + 1,
          per_page: params.per_page ?? 10,
        },
      }
    );

    const paginated = data.data;

    return {
      pageNumber: paginated.current_page - 1,
      totalPages: paginated.last_page,
      totalDataCount: paginated.total,
      data: paginated.data,
    };
  },
};

export default API;
