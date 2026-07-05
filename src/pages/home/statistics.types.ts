import type { IDashboardStats } from "@apis/dashboard/type";

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

export function mapDashboardStatsToRequestStatus(stats: IDashboardStats) {
  return [
    { name: "معلقة", count: stats.pending_requests, color: "#fb8c00" },
    { name: "مكتملة", count: stats.completed_requests, color: "#2d5a3d" },
    { name: "عاجلة معلقة", count: stats.urgent_pending_requests, color: "#c62828" },
  ];
}

export interface OrderTrend {
  period: string;
  orders: number;
  completed: number;
  cancelled: number;
}

export interface CategoryDistribution {
  name: string;
  count: number;
  color: string;
}

export interface RatingDistribution {
  stars: number;
  count: number;
}

export interface RecentOrder {
  id: string;
  clientName: string;
  craftsmanName: string;
  service: string;
  status: "completed" | "pending" | "cancelled" | "in_progress";
  date: string;
  amount: number;
}

export interface TopCraftsman {
  id: string;
  name: string;
  specialty: string;
  completedOrders: number;
  rating: number;
  reviewsCount: number;
  status: "active" | "inactive";
  avatarInitials: string;
}

export interface RecentReview {
  id: string;
  clientName: string;
  craftsmanName: string;
  rating: number;
  comment: string;
  date: string;
  service: string;
}

export const MOCK_KPI_CARDS: KPICard[] = [
  { id: "users", labelAr: "إجمالي المستخدمين", value: 12480, change: 8.2, changePositive: true, icon: "People", color: "#2e7d32", bgColor: "#e8f5e9" },
  { id: "craftsmen", labelAr: "إجمالي الحرفيين", value: 3241, change: 5.1, changePositive: true, icon: "Build", color: "#1565c0", bgColor: "#e3f2fd" },
  { id: "orders", labelAr: "إجمالي الطلبات", value: 28954, change: 12.7, changePositive: true, icon: "Assignment", color: "#e65100", bgColor: "#fff3e0" },
  { id: "reviews", labelAr: "إجمالي التقييمات", value: 19320, change: -2.3, changePositive: false, icon: "Star", color: "#6a1b9a", bgColor: "#f3e5f5" },
  { id: "active_craftsmen", labelAr: "حرفيون نشطون", value: 2876, change: 3.4, changePositive: true, icon: "CheckCircle", color: "#00695c", bgColor: "#e0f2f1" },
  { id: "stopped_craftsmen", labelAr: "حرفيون متوقفون", value: 365, change: -1.8, changePositive: false, icon: "Block", color: "#c62828", bgColor: "#ffebee" },
];

export const MOCK_ORDER_TREND: OrderTrend[] = [
  { period: "يوليو", orders: 1820, completed: 1540, cancelled: 280 },
  { period: "أغسطس", orders: 2100, completed: 1830, cancelled: 270 },
  { period: "سبتمبر", orders: 1950, completed: 1680, cancelled: 270 },
  { period: "أكتوبر", orders: 2400, completed: 2050, cancelled: 350 },
  { period: "نوفمبر", orders: 2800, completed: 2420, cancelled: 380 },
  { period: "ديسمبر", orders: 3200, completed: 2780, cancelled: 420 },
  { period: "يناير", orders: 2950, completed: 2560, cancelled: 390 },
  { period: "فبراير", orders: 3100, completed: 2710, cancelled: 390 },
  { period: "مارس", orders: 3450, completed: 3010, cancelled: 440 },
  { period: "أبريل", orders: 3800, completed: 3310, cancelled: 490 },
  { period: "مايو", orders: 4100, completed: 3580, cancelled: 520 },
  { period: "يونيو", orders: 4350, completed: 3800, cancelled: 550 },
];

export const MOCK_CATEGORY_DISTRIBUTION: CategoryDistribution[] = [
  { name: "سباكة", count: 5420, color: "#2e7d32" },
  { name: "كهرباء", count: 4870, color: "#1565c0" },
  { name: "نجارة", count: 3980, color: "#e65100" },
  { name: "دهان", count: 3210, color: "#6a1b9a" },
  { name: "تكييف", count: 2760, color: "#00695c" },
  { name: "أخرى", count: 2890, color: "#546e7a" },
];

export const MOCK_RATING_DISTRIBUTION: RatingDistribution[] = [
  { stars: 5, count: 9820 },
  { stars: 4, count: 5410 },
  { stars: 3, count: 2380 },
  { stars: 2, count: 980 },
  { stars: 1, count: 730 },
];

export const MOCK_RECENT_ORDERS: RecentOrder[] = [
  { id: "ORD-7821", clientName: "أحمد محمد", craftsmanName: "خالد العمري", service: "سباكة", status: "completed", date: "2024-06-15", amount: 450 },
  { id: "ORD-7822", clientName: "فاطمة علي", craftsmanName: "محمود سالم", service: "كهرباء", status: "in_progress", date: "2024-06-15", amount: 320 },
  { id: "ORD-7823", clientName: "سارة حسن", craftsmanName: "يوسف كمال", service: "دهان", status: "pending", date: "2024-06-14", amount: 780 },
  { id: "ORD-7824", clientName: "محمد عبدالله", craftsmanName: "أحمد فاروق", service: "نجارة", status: "completed", date: "2024-06-14", amount: 1200 },
  { id: "ORD-7825", clientName: "نورا إبراهيم", craftsmanName: "كريم عادل", service: "تكييف", status: "cancelled", date: "2024-06-13", amount: 550 },
  { id: "ORD-7826", clientName: "عمر مصطفى", craftsmanName: "طارق منصور", service: "سباكة", status: "completed", date: "2024-06-13", amount: 290 },
  { id: "ORD-7827", clientName: "ريم الشمري", craftsmanName: "حسام وليد", service: "كهرباء", status: "in_progress", date: "2024-06-12", amount: 410 },
];

export const MOCK_TOP_CRAFTSMEN: TopCraftsman[] = [
  { id: "C001", name: "خالد العمري", specialty: "سباكة", completedOrders: 342, rating: 4.9, reviewsCount: 318, status: "active", avatarInitials: "خع" },
  { id: "C002", name: "محمود سالم", specialty: "كهرباء", completedOrders: 298, rating: 4.8, reviewsCount: 275, status: "active", avatarInitials: "مس" },
  { id: "C003", name: "يوسف كمال", specialty: "دهان", completedOrders: 271, rating: 4.7, reviewsCount: 254, status: "active", avatarInitials: "يك" },
  { id: "C004", name: "أحمد فاروق", specialty: "نجارة", completedOrders: 258, rating: 4.8, reviewsCount: 241, status: "active", avatarInitials: "أف" },
  { id: "C005", name: "كريم عادل", specialty: "تكييف", completedOrders: 234, rating: 4.6, reviewsCount: 220, status: "active", avatarInitials: "كع" },
];

export const MOCK_RECENT_REVIEWS: RecentReview[] = [
  { id: "R001", clientName: "أحمد محمد", craftsmanName: "خالد العمري", rating: 5, comment: "عمل ممتاز وسريع، أنصح به بشدة", date: "2024-06-15", service: "سباكة" },
  { id: "R002", clientName: "فاطمة علي", craftsmanName: "محمود سالم", rating: 4, comment: "خدمة جيدة جداً وسعر مناسب", date: "2024-06-14", service: "كهرباء" },
  { id: "R003", clientName: "سارة حسن", craftsmanName: "يوسف كمال", rating: 5, comment: "دقيق في العمل ومحترف", date: "2024-06-14", service: "دهان" },
  { id: "R004", clientName: "محمد عبدالله", craftsmanName: "أحمد فاروق", rating: 3, comment: "الخدمة مقبولة لكن التأخير كان ملحوظاً", date: "2024-06-13", service: "نجارة" },
  { id: "R005", clientName: "نورا إبراهيم", craftsmanName: "كريم عادل", rating: 5, comment: "ممتاز جداً، سيتم التعامل معه مجدداً", date: "2024-06-13", service: "تكييف" },
];

export type DateRangePreset = "7d" | "30d" | "90d" | "12m";
export const DATE_RANGE_OPTIONS: { value: DateRangePreset; labelAr: string }[] = [
  { value: "7d", labelAr: "آخر 7 أيام" },
  { value: "30d", labelAr: "آخر 30 يوم" },
  { value: "90d", labelAr: "آخر 3 أشهر" },
  { value: "12m", labelAr: "آخر 12 شهر" },
];
