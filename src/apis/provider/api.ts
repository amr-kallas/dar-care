import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import type { APIList } from "../../types/apiType";
import {
  IAdminProvider,
  IAdminProvidersResponse,
  IGetAdminProvidersParams,
  IUpdateProviderStatusBody,
  IUpdateProviderVerificationBody,
} from "./type";

const API = {
  getAdminProviders: async (
    params: IGetAdminProvidersParams
  ): Promise<APIList<IAdminProvider>> => {
    const { data } = await axios.get<IAdminProvidersResponse>(
      API_ROUTES.ADMIN.GET_PROVIDERS,
      {
        params: {
          status: params.status ?? "",
          search: params.search ?? "",
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
  deleteAdminProvider: async (id: string) => {
    const { data } = await axios.delete(API_ROUTES.ADMIN.DELETE_PROVIDER(id));
    return data;
  },
  updateProviderStatus: async (
    id: string,
    body: IUpdateProviderStatusBody
  ) => {
    const { data } = await axios.patch(
      API_ROUTES.ADMIN.UPDATE_PROVIDER_STATUS(id),
      body
    );
    return data;
  },
  updateProviderVerification: async (
    id: string,
    body: IUpdateProviderVerificationBody
  ) => {
    const { data } = await axios.patch(
      API_ROUTES.ADMIN.UPDATE_PROVIDER_VERIFICATION(id),
      body
    );
    return data;
  },
};

export default API;
