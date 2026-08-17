export type IDashboardStats = {
  total_customers: number;
  total_providers: number;
  active_now_providers: number;
  total_requests: number;
  pending_requests: number;
  completed_requests: number;
  urgent_pending_requests: number;
};

export type IDashboardStatsResponse = {
  status: string;
  data: IDashboardStats;
};

export type IRequestStatus =
  | "pending"
  | "accepted"
  | "rejected"
  | "delayed"
  | "completed"
  | "cancelled";

export type INamedEntity = {
  id: number;
  name: string;
};

export type ILatestRequest = {
  id: number;
  customer: INamedEntity | null;
  artisan: INamedEntity | null;
  category: INamedEntity | null;
  status: IRequestStatus;
  urgency: string | null;
  scheduled_at: string | null;
  created_at: string;
};

export type ILatestRating = {
  id: number;
  rating: number;
  comment: string | null;
  customer: INamedEntity | null;
  artisan: INamedEntity | null;
  service_request: { id: number } | null;
  created_at: string;
};

export type ITopArtisan = {
  id: number;
  name: string;
  profile_image: string | null;
  average_rating: number;
  ratings_count: number;
  completed_requests_count: number;
  categories: INamedEntity[];
};

export type ICategoryDistributionRow = {
  category_id: number;
  name: string;
  requests_count: number;
  percentage: number;
};

export type IDashboardOverview = {
  latest_requests: ILatestRequest[];
  latest_ratings: ILatestRating[];
  top_artisans: ITopArtisan[];
  category_distribution: {
    total_requests: number;
    categories: ICategoryDistributionRow[];
  };
};

export type IMonthStatusBucket = {
  count: number;
  percentage: number;
};

export type IMonthlyStatisticsMonth = {
  month: number;
  month_key: string;
  month_name: string;
  month_name_ar: string;
  total: number;
  annual_percentage: number;
  statuses: Record<IRequestStatus, IMonthStatusBucket>;
};

export type IMonthlyStatistics = {
  year: number;
  annual_total: number;
  months: IMonthlyStatisticsMonth[];
  year_totals: Record<IRequestStatus | "total", number>;
};

export type IApiEnvelope<T> = {
  success: boolean;
  message: string;
  data: T;
  errors: unknown;
};
