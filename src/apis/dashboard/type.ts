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
