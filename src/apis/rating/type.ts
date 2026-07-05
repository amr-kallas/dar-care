export type IRatingUser = {
  id: number;
  name: string;
  phone: string;
};

export type IRatingProvider = {
  id: number;
  name: string;
};

export type IRatingServiceRequest = {
  id: number;
  user_id: number;
  provider_id: number;
  category_id: number;
  address_id: number | null;
  description: string;
  urgency: string;
  image: string | null;
  status: string;
  temp_latitude: number | null;
  temp_longitude: number | null;
  temp_label: string | null;
  scheduled_at: string | null;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
};

export type IAdminRating = {
  id: number;
  user_id: number;
  provider_id: number;
  service_request_id: number;
  rating: number;
  comment: string;
  created_at: string;
  updated_at: string;
  user: IRatingUser;
  provider: IRatingProvider;
  service_request: IRatingServiceRequest;
};

export type IAdminRatingsPaginated = {
  current_page: number;
  data: IAdminRating[];
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

export type IAdminRatingsResponse = {
  status: string;
  data: IAdminRatingsPaginated;
};

export type IGetAdminRatingsParams = {
  rating?: string;
  provider_id?: string;
  page?: number;
  per_page?: number;
};
