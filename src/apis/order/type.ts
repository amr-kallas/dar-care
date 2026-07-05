export type IServiceRequestUser = {
  id: number;
  name: string;
  phone: string;
};

export type IServiceRequestProvider = {
  id: number;
  name: string;
  phone: string;
};

export type IServiceRequestCategory = {
  id: number;
  name: string;
};

export type IServiceRequestAddress = {
  id: number;
  label?: string;
} | null;

export type IAdminServiceRequest = {
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
  user: IServiceRequestUser;
  provider: IServiceRequestProvider;
  category: IServiceRequestCategory;
  address: IServiceRequestAddress;
};

export type IAdminServiceRequestsPaginated = {
  current_page: number;
  data: IAdminServiceRequest[];
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

export type IAdminServiceRequestsResponse = {
  status: string;
  data: IAdminServiceRequestsPaginated;
};

export type IGetAdminServiceRequestsParams = {
  status?: string;
  urgency?: string;
  page?: number;
  per_page?: number;
};
