import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useMutation, useQuery } from "@tanstack/react-query";
import API from "./api";
import { IGetAdminProvidersParams } from "./type";

export const keys = createQueryKeys("provider", {
  getAdminProviders: (params: IGetAdminProvidersParams) => ({
    queryFn: () => API.getAdminProviders(params),
    queryKey: [params],
  }),
});

export const queries = {
  GetAdminProviders: (params: IGetAdminProvidersParams) =>
    useQuery(keys.getAdminProviders(params)),
  deleteAdminProvider: () =>
    useMutation({ mutationFn: API.deleteAdminProvider }),
  updateProviderStatus: () =>
    useMutation({
      mutationFn: ({
        id,
        status,
      }: {
        id: string;
        status: string;
      }) => API.updateProviderStatus(id, { status }),
    }),
};
