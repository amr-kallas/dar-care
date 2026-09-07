export type IProviderCategory = {
  id: number;
  name: string;
  pivot: {
    provider_id: number;
    category_id: number;
  };
};

export type IAdminProvider = {
  id: number;
  name: string;
  phone: string;
  email: string;
  fcm_token: string | null;
  years_of_experience: number;
  bio: string;
  profile_image: string | null;
  identity_image: string | null;
  status: string;
  verification_status: IProviderVerificationStatus;
  rejection_reason: string | null;
  rating_avg: string;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
  categories: IProviderCategory[];
};

export type IAdminProvidersPaginated = {
  current_page: number;
  data: IAdminProvider[];
  first_page_url: string;
  from: number | null;
  last_page: number;
  last_page_url: string;
  next_page_url: string | null;
  path: string;
  per_page: number;
  prev_page_url: string | null;
  to: number | null;
  total: number;
};

export type IAdminProvidersResponse = {
  status: string;
  data: IAdminProvidersPaginated;
};

export type IGetAdminProvidersParams = {
  status?: string;
  search?: string;
  page?: number;
  per_page?: number;
};

export type IUpdateProviderStatusBody = {
  status: string;
};

export type IProviderVerificationStatus = "pending" | "approved" | "rejected";

export type IUpdateProviderVerificationBody = {
  verification_status: IProviderVerificationStatus;
  rejection_reason?: string;
};
