import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useMutation, useQuery } from "@tanstack/react-query";
import API from "./api";
import {
  IGetAdminProvidersParams,
  IProviderVerificationStatus,
} from "./type";

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
  updateProviderVerification: () =>
    useMutation({
      mutationFn: ({
        id,
        verification_status,
        rejection_reason,
      }: {
        id: string;
        verification_status: IProviderVerificationStatus;
        rejection_reason?: string;
      }) =>
        API.updateProviderVerification(id, {
          verification_status,
          ...(rejection_reason ? { rejection_reason } : {}),
        }),
    }),
};
