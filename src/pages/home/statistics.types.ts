import type {
  IDashboardOverview,
  IDashboardStats,
  IMonthlyStatistics,
  IRequestStatus,
} from "@apis/dashboard/type";

export interface KPICard {
  id: string;
  labelAr: string;
  value: number;
  change?: number;
  changePositive?: boolean;
  icon: string;
  color: string;
  bgColor: string;
}

export function mapDashboardStatsToKpiCards(stats: IDashboardStats): KPICard[] {
  return [
    {
      id: "customers",
      labelAr: "إجمالي العملاء",
      value: stats.total_customers,
      icon: "People",
      color: "#2e7d32",
      bgColor: "#e8f5e9",
    },
    {
      id: "providers",
      labelAr: "إجمالي الحرفيين",
      value: stats.total_providers,
      icon: "Build",
      color: "#1565c0",
      bgColor: "#e3f2fd",
    },
    {
      id: "requests",
      labelAr: "إجمالي الطلبات",
      value: stats.total_requests,
      icon: "Assignment",
      color: "#e65100",
      bgColor: "#fff3e0",
    },
    {
      id: "active_providers",
      labelAr: "حرفيون نشطون الآن",
      value: stats.active_now_providers,
      icon: "CheckCircle",
      color: "#00695c",
      bgColor: "#e0f2f1",
    },
  ];
}

export const STATUS_LABELS_AR: Record<IRequestStatus, string> = {
  pending: "معلقة",
  accepted: "مقبولة",
  rejected: "مرفوضة",
  delayed: "مؤجلة",
  completed: "مكتملة",
  cancelled: "ملغاة",
};

export const STATUS_COLORS: Record<IRequestStatus, string> = {
  pending: "#fb8c00",
  accepted: "#1565c0",
  rejected: "#8d6e63",
  delayed: "#6a1b9a",
  completed: "#2d5a3d",
  cancelled: "#c62828",
};

const STATUS_ORDER: IRequestStatus[] = [
  "pending",
  "accepted",
  "completed",
  "delayed",
  "rejected",
  "cancelled",
];

const CATEGORY_PALETTE = [
  "#2e7d32",
  "#1565c0",
  "#e65100",
  "#6a1b9a",
  "#00695c",
  "#c62828",
  "#546e7a",
  "#ad1457",
  "#4527a0",
  "#00838f",
];

export interface OrderTrend {
  period: string;
  orders: number;
  completed: number;
  cancelled: number;
}

export interface CategoryDistribution {
  name: string;
  count: number;
  percentage: number;
  color: string;
}

export interface RatingDistribution {
  stars: number;
  count: number;
}

export interface RecentOrder {
  id: number;
  clientName: string;
  craftsmanName: string;
  service: string;
  status: IRequestStatus;
  urgency: string | null;
  date: string;
}

export interface TopCraftsman {
  id: number;
  name: string;
  specialty: string;
  completedOrders: number;
  rating: number;
  reviewsCount: number;
  avatarInitials: string;
  avatarUrl: string | null;
}

export interface RecentReview {
  id: number;
  clientName: string;
  craftsmanName: string;
  rating: number;
  comment: string;
  date: string;
  requestId: number | null;
}

const initialsOf = (name: string) =>
  name
    .trim()
    .split(/\s+/)
    .slice(0, 2)
    .map((word) => word.charAt(0))
    .join("");

/** Monthly totals per status, shaped for the trend area chart. */
export function mapMonthlyToOrderTrend(
  monthly: IMonthlyStatistics
): OrderTrend[] {
  return monthly.months.map((month) => ({
    period: month.month_name_ar,
    orders: month.total,
    completed: month.statuses.completed.count,
    cancelled: month.statuses.cancelled.count,
  }));
}

/** Yearly totals per status, shaped for the status bar chart. */
export function mapYearTotalsToRequestStatus(monthly: IMonthlyStatistics) {
  return STATUS_ORDER.map((status) => ({
    name: STATUS_LABELS_AR[status],
    count: monthly.year_totals[status] ?? 0,
    color: STATUS_COLORS[status],
  }));
}

export function mapCategoryDistribution(
  overview: IDashboardOverview
): CategoryDistribution[] {
  return overview.category_distribution.categories.map((category, idx) => ({
    name: category.name,
    count: category.requests_count,
    percentage: category.percentage,
    color: CATEGORY_PALETTE[idx % CATEGORY_PALETTE.length],
  }));
}

export function mapLatestRequests(overview: IDashboardOverview): RecentOrder[] {
  return overview.latest_requests.map((request) => ({
    id: request.id,
    clientName: request.customer?.name ?? "—",
    craftsmanName: request.artisan?.name ?? "—",
    service: request.category?.name ?? "—",
    status: request.status,
    urgency: request.urgency,
    date: request.created_at,
  }));
}

export function mapTopArtisans(overview: IDashboardOverview): TopCraftsman[] {
  return overview.top_artisans.map((artisan) => ({
    id: artisan.id,
    name: artisan.name,
    specialty:
      artisan.categories.map((category) => category.name).join("، ") || "—",
    completedOrders: artisan.completed_requests_count,
    rating: artisan.average_rating,
    reviewsCount: artisan.ratings_count,
    avatarInitials: initialsOf(artisan.name),
    avatarUrl: artisan.profile_image,
  }));
}

export function mapLatestRatings(overview: IDashboardOverview): RecentReview[] {
  return overview.latest_ratings.map((rating) => ({
    id: rating.id,
    clientName: rating.customer?.name ?? "—",
    craftsmanName: rating.artisan?.name ?? "—",
    rating: rating.rating,
    comment: rating.comment ?? "",
    date: rating.created_at,
    requestId: rating.service_request?.id ?? null,
  }));
}

/**
 * Star breakdown of the ratings returned by the overview endpoint. The API
 * only exposes the latest ratings, so this reflects that sample — not every
 * rating on record.
 */
export function mapRatingDistribution(
  overview: IDashboardOverview
): RatingDistribution[] {
  return [5, 4, 3, 2, 1].map((stars) => ({
    stars,
    count: overview.latest_ratings.filter(
      (rating) => Math.round(rating.rating) === stars
    ).length,
  }));
}
