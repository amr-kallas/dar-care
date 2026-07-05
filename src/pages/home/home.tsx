import React, { useMemo } from "react";
import { queries } from "@apis/dashboard/queries";
import {
  Assignment as AssignmentIcon,
  BarChart as BarChartIcon,
  Block as BlockIcon,
  Build as BuildIcon,
  CheckCircle as CheckCircleIcon,
  People as PeopleIcon,
  PieChart as PieChartIcon,
  Star as StarIcon,
  TableChart as TableChartIcon,
  TrendingDown as TrendingDownIcon,
  TrendingUp as TrendingUpIcon,
} from "@mui/icons-material";
import {
  Avatar,
  Box,
  Card,
  CardContent,
  Chip,
  Divider,
  Grid,
  LinearProgress,
  Rating,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Tooltip,
  Typography,
} from "@mui/material";
import TableRowStriped from "@components/tables/PaginationTable/TableRowStriped";
import {
  Area,
  AreaChart,
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  Legend,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip as RechartsTooltip,
  XAxis,
  YAxis,
} from "recharts";
import {
  MOCK_CATEGORY_DISTRIBUTION,
  MOCK_ORDER_TREND,
  MOCK_RATING_DISTRIBUTION,
  MOCK_RECENT_ORDERS,
  MOCK_RECENT_REVIEWS,
  MOCK_TOP_CRAFTSMEN,
  mapDashboardStatsToKpiCards,
  mapDashboardStatsToRequestStatus,
  type KPICard,
  type RecentOrder,
  type RecentReview,
  type TopCraftsman,
} from "./statistics.types.ts";
import Loading from "@components/feedbacks/loading";

const PRIMARY_GREEN = "#2d5a3d";
const LIGHT_GREEN = "#e8f5e9";

const formatInt = (value: number) =>
  new Intl.NumberFormat("en-US", { maximumFractionDigits: 0 }).format(value);

const formatCompact = (value: number) =>
  new Intl.NumberFormat("en-US", { notation: "compact", maximumFractionDigits: 1 }).format(value);

const ICON_MAP: Record<string, React.ElementType> = {
  People: PeopleIcon,
  Build: BuildIcon,
  Assignment: AssignmentIcon,
  Star: StarIcon,
  CheckCircle: CheckCircleIcon,
  Block: BlockIcon,
};

const STATUS_MAP: Record<
  RecentOrder["status"],
  { label: string; color: "success" | "warning" | "error" | "info" }
> = {
  completed: { label: "مكتمل", color: "success" },
  pending: { label: "معلق", color: "warning" },
  cancelled: { label: "ملغي", color: "error" },
  in_progress: { label: "جارٍ", color: "info" },
};

const SectionHeader = ({ title, icon }: { title: string; icon: React.ReactNode }) => (
  <Box display="flex" alignItems="center" gap={1} mb={2.5} flexDirection="row" justifyContent="flex-end">
    <Box sx={{ width: 4, height: 24, bgcolor: PRIMARY_GREEN, borderRadius: 2 }} />
    <Box sx={{ color: PRIMARY_GREEN }}>{icon}</Box>
    <Typography variant="h6" fontWeight={700}>
      {title}
    </Typography>
  </Box>
);

const KpiCard = ({ card, index }: { card: KPICard; index: number }) => {
  const IconComponent = ICON_MAP[card.icon] ?? PeopleIcon;
  const isPositive = card.changePositive ?? true;
  const showChange = card.change !== undefined;
  return (
    <Card
      elevation={0}
      sx={{
        borderRadius: 3,
        border: "1px solid",
        borderColor: "grey.200",
        transition: "all 0.2s ease",
        animation: "fadeSlide 0.35s ease both",
        animationDelay: `${index * 60}ms`,
        "@keyframes fadeSlide": {
          from: { opacity: 0, transform: "translateY(10px)" },
          to: { opacity: 1, transform: "translateY(0)" },
        },
        "&:hover": { transform: "translateY(-3px)", boxShadow: 3, borderColor: card.color },
      }}
    >
      <CardContent sx={{ p: 2.5 }}>
        <Box display="flex" justifyContent="space-between" mb={1.5} flexDirection="row">
          <Box>
            <Typography variant="body2" color="text.secondary" fontWeight={600}>
              {card.labelAr}
            </Typography>
            <Typography variant="h5" fontWeight={800} sx={{ direction: "ltr", textAlign: "left" }}>
              {formatInt(card.value)}
            </Typography>
          </Box>
          <Box
            sx={{
              width: 46,
              height: 46,
              borderRadius: 2,
              bgcolor: card.bgColor,
              display: "grid",
              placeItems: "center",
            }}
          >
            <IconComponent sx={{ color: card.color, fontSize: 24 }} />
          </Box>
        </Box>
        {showChange && (
          <Box display="flex" alignItems="center" gap={0.5} justifyContent="flex-start" flexDirection="row">
            {isPositive ? (
              <TrendingUpIcon sx={{ fontSize: 15, color: "success.main" }} />
            ) : (
              <TrendingDownIcon sx={{ fontSize: 15, color: "error.main" }} />
            )}
            <Typography variant="caption" fontWeight={700} color={isPositive ? "success.main" : "error.main"}>
              {isPositive ? "+" : ""}
              {card.change}%
            </Typography>
            <Typography variant="caption" color="text.secondary">
              مقارنة بالفترة السابقة
            </Typography>
          </Box>
        )}
      </CardContent>
    </Card>
  );
};

const Home: React.FC = () => {
  const { data: stats, isLoading } = queries.GetDashboardStats();
  const kpiCards = useMemo(
    () => (stats ? mapDashboardStatsToKpiCards(stats) : []),
    [stats]
  );
  const requestStatus = useMemo(
    () => (stats ? mapDashboardStatsToRequestStatus(stats) : []),
    [stats]
  );
  const filteredTrend = MOCK_ORDER_TREND;

  const categoryTotal = useMemo(
    () => MOCK_CATEGORY_DISTRIBUTION.reduce((sum, row) => sum + row.count, 0),
    []
  );
  const ratingTotal = useMemo(
    () => MOCK_RATING_DISTRIBUTION.reduce((sum, row) => sum + row.count, 0),
    []
  );

  return (
    <Box
      sx={{
        p: { xs: 2, sm: 3 },
        maxWidth: 1450,
        mx: "auto",
        direction: "rtl",
        textAlign: "right",
        "& .MuiTableCell-root": { textAlign: "right" },
      }}
    >
      <Typography variant="h5" fontWeight={800} mb={3}>
        الإحصائيات والتحليلات
      </Typography>

      {isLoading ? (
        <Box py={6} display="flex" justifyContent="center">
          <Loading />
        </Box>
      ) : (
        <>
      <Grid container spacing={2.2} mb={3}>
        {kpiCards.map((card, i) => (
          <Grid item xs={12} sm={6} lg={3} key={card.id}>
            <KpiCard card={card} index={i} />
          </Grid>
        ))}
      </Grid>

      <Grid container spacing={2.5} mb={3}>
        <Grid item xs={12} lg={8}>
          <Card elevation={0} sx={{ borderRadius: 3, border: "1px solid", borderColor: "grey.200", height: "100%" }}>
            <CardContent sx={{ p: 2.5 }}>
              <SectionHeader title="اتجاه الطلبات" icon={<BarChartIcon fontSize="small" />} />
              <ResponsiveContainer width="100%" height={280}>
                <AreaChart data={filteredTrend} margin={{ top: 5, right: 5, left: -20, bottom: 0 }}>
                  <defs>
                    <linearGradient id="ordersGrad" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor={PRIMARY_GREEN} stopOpacity={0.22} />
                      <stop offset="95%" stopColor={PRIMARY_GREEN} stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" vertical={false} />
                  <XAxis dataKey="period" axisLine={false} tickLine={false} tick={{ fontSize: 11 }} />
                  <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 11 }} />
                  <RechartsTooltip
                    formatter={(value) => [formatInt(Number(value ?? 0)), ""]}
                    contentStyle={{ direction: "rtl", borderRadius: 10 }}
                  />
                  <Legend wrapperStyle={{ direction: "rtl" }} />
                  <Area type="monotone" dataKey="orders" stroke={PRIMARY_GREEN} strokeWidth={2.2} fill="url(#ordersGrad)" />
                  <Area type="monotone" dataKey="completed" stroke="#1565c0" strokeWidth={1.8} fill="transparent" />
                  <Area type="monotone" dataKey="cancelled" stroke="#c62828" strokeWidth={1.8} fill="transparent" />
                </AreaChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} sm={6} lg={4}>
          <Card elevation={0} sx={{ borderRadius: 3, border: "1px solid", borderColor: "grey.200", height: "100%" }}>
            <CardContent sx={{ p: 2.5 }}>
              <SectionHeader title="توزيع الفئات" icon={<PieChartIcon fontSize="small" />} />
              <ResponsiveContainer width="100%" height={190}>
                <PieChart>
                  <Pie data={MOCK_CATEGORY_DISTRIBUTION} dataKey="count" nameKey="name" cx="50%" cy="50%" innerRadius={45} outerRadius={78}>
                    {MOCK_CATEGORY_DISTRIBUTION.map((row, idx) => (
                      <Cell key={`${row.name}-${idx}`} fill={row.color} />
                    ))}
                  </Pie>
                  <RechartsTooltip formatter={(value) => [formatInt(Number(value ?? 0)), "طلب"]} />
                </PieChart>
              </ResponsiveContainer>
              <Box mt={1} display="flex" flexDirection="column" gap={1}>
                {MOCK_CATEGORY_DISTRIBUTION.map((row) => (
                  <Box key={row.name} display="flex" alignItems="center" gap={1} flexDirection="row-reverse'">
                    <Box sx={{ width: 10, height: 10, borderRadius: "50%", bgcolor: row.color }} />
                    <Typography variant="caption" sx={{ flexGrow: 1 }}>
                      {row.name}
                    </Typography>
                    <Typography variant="caption" fontWeight={700}>
                      {((row.count / categoryTotal) * 100).toFixed(1)}%
                    </Typography>
                  </Box>
                ))}
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Grid container spacing={2.5} mb={3}>
        <Grid item xs={12} md={6}>
          <Card elevation={0} sx={{ borderRadius: 3, border: "1px solid", borderColor: "grey.200", height: "100%" }}>
            <CardContent sx={{ p: 2.5 }}>
              <SectionHeader title="توزيع التقييمات" icon={<StarIcon fontSize="small" />} />
              <Box display="flex" flexDirection="column" gap={1.3}>
                {MOCK_RATING_DISTRIBUTION.slice().reverse().map((row) => (
                  <Box key={row.stars} display="flex" alignItems="center" gap={1.5} flexDirection="row">
                    <Typography variant="body2" fontWeight={700} sx={{ minWidth: 36 }}>
                      {row.stars}★
                    </Typography>
                    <LinearProgress
                      variant="determinate"
                      value={(row.count / ratingTotal) * 100}
                      sx={{ flexGrow: 1, height: 8, borderRadius: 4 }}
                    />
                    <Typography variant="caption" sx={{ minWidth: 60, textAlign: "right", direction: "ltr" }}>
                      {formatCompact(row.count)}
                    </Typography>
                  </Box>
                ))}
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} md={6}>
          <Card elevation={0} sx={{ borderRadius: 3, border: "1px solid", borderColor: "grey.200", height: "100%" }}>
            <CardContent sx={{ p: 2.5 }}>
              <SectionHeader title="الطلبات حسب الحالة" icon={<BarChartIcon fontSize="small" />} />
              <ResponsiveContainer width="100%" height={210}>
                <BarChart data={requestStatus} margin={{ top: 8, right: 5, left: -20, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" vertical={false} />
                  <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{ fontSize: 11 }} />
                  <YAxis axisLine={false} tickLine={false} tick={{ fontSize: 11 }} allowDecimals={false} />
                  <RechartsTooltip formatter={(value) => [formatInt(Number(value ?? 0)), "طلب"]} />
                  <Bar dataKey="count" radius={[4, 4, 0, 0]}>
                    {requestStatus.map((row) => (
                      <Cell key={row.name} fill={row.color} />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Grid container spacing={2.5}>
        <Grid item xs={12}>
          <Card elevation={0} sx={{ borderRadius: 3, border: "1px solid", borderColor: "grey.200" }}>
            <CardContent sx={{ p: 2.5, pb: 1 }}>
              <SectionHeader title="أحدث الطلبات" icon={<TableChartIcon fontSize="small" />} />
            </CardContent>
            <Box sx={{ width: "100%", overflowX: "auto" }}>
              <TableContainer sx={{ minWidth: 620 }}>
                <Table size="small">
                  <TableHead
                    sx={{
                      "& .MuiTableCell-root": {
                        bgcolor: "primary.main",
                        color: "white",
                        fontWeight: 700,
                        whiteSpace: "nowrap",
                      },
                    }}
                  >
                    <TableRow>
                      <TableCell align="right">رقم الطلب</TableCell>
                      <TableCell align="right">العميل</TableCell>
                      <TableCell align="right">الحرفي</TableCell>
                      <TableCell align="right">الخدمة</TableCell>
                      <TableCell align="right">الحالة</TableCell>
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {MOCK_RECENT_ORDERS.map((order) => {
                      const st = STATUS_MAP[order.status];
                      return (
                        <TableRowStriped key={order.id}>
                          <TableCell align="right" sx={{ direction: "ltr", fontWeight: 600 }}>
                            {order.id}
                          </TableCell>
                          <TableCell align="right" sx={{ whiteSpace: "nowrap" }}>
                            {order.clientName}
                          </TableCell>
                          <TableCell align="right" sx={{ whiteSpace: "nowrap" }}>
                            {order.craftsmanName}
                          </TableCell>
                          <TableCell align="right">
                            <Chip
                              size="small"
                              label={order.service}
                              sx={{ bgcolor: LIGHT_GREEN, color: PRIMARY_GREEN, fontWeight: 700 }}
                            />
                          </TableCell>
                          <TableCell align="right">
                            <Chip size="small" label={st.label} color={st.color} variant="outlined" />
                          </TableCell>
                        </TableRowStriped>
                      );
                    })}
                  </TableBody>
                </Table>
              </TableContainer>
            </Box>
          </Card>
        </Grid>
      </Grid>

      <Grid container spacing={2.5} sx={{ mt: 0 }}>
        <Grid item xs={12} md={6}>
          <Card elevation={0} sx={{ borderRadius: 3, border: "1px solid", borderColor: "grey.200", height: "100%" }}>
            <CardContent sx={{ p: 2.5 }}>
              <SectionHeader title="أفضل الحرفيين" icon={<BuildIcon fontSize="small" />} />
              <Box display="flex" flexDirection="column" gap={1.5}>
                {MOCK_TOP_CRAFTSMEN.map((craftsman: TopCraftsman, idx: number) => (
                  <Box key={craftsman.id}>
                    <Box display="flex" alignItems="center" gap={1.2} flexDirection="row">
                      <Typography variant="caption" fontWeight={800} color="text.secondary" sx={{ direction: "ltr" }}>
                        #{idx + 1}
                      </Typography>
                      <Avatar sx={{ width: 34, height: 34, bgcolor: PRIMARY_GREEN, fontSize: "0.75rem" }}>
                        {craftsman.avatarInitials}
                      </Avatar>
                      <Box sx={{ minWidth: 0, flexGrow: 1 }}>
                        <Typography variant="body2" fontWeight={600} noWrap>
                          {craftsman.name}
                        </Typography>
                        <Typography variant="caption" color="text.secondary">
                          {craftsman.specialty} · {formatInt(craftsman.completedOrders)}
                        </Typography>
                      </Box>
                      <Typography variant="caption" fontWeight={700}>
                        {craftsman.rating}
                      </Typography>
                    </Box>
                    {idx < MOCK_TOP_CRAFTSMEN.length - 1 && <Divider sx={{ mt: 1.2 }} />}
                  </Box>
                ))}
              </Box>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} md={6}>
          <Card elevation={0} sx={{ borderRadius: 3, border: "1px solid", borderColor: "grey.200", height: "100%" }}>
            <CardContent sx={{ p: 2.5 }}>
              <SectionHeader title="أحدث التقييمات" icon={<StarIcon fontSize="small" />} />
              <Box display="flex" flexDirection="column" gap={1.5}>
                {MOCK_RECENT_REVIEWS.map((review: RecentReview, idx: number) => (
                  <Box key={review.id}>
                    <Box display="flex" alignItems="flex-start" gap={1.2} flexDirection="row">
                      <Avatar sx={{ width: 32, height: 32, bgcolor: "#1565c0", fontSize: "0.7rem" }}>
                        {review.clientName.charAt(0)}
                      </Avatar>
                      <Box sx={{ minWidth: 0, flexGrow: 1 }}>
                        <Box display="flex" justifyContent="space-between" alignItems="center" flexDirection="row">
                          <Typography variant="caption" fontWeight={700} noWrap>
                            {review.clientName}
                          </Typography>
                          <Rating value={review.rating} readOnly size="small" sx={{ fontSize: 13 }} />
                        </Box>
                        <Tooltip title={review.comment}>
                          <Typography
                            variant="caption"
                            color="text.secondary"
                            sx={{
                              display: "-webkit-box",
                              WebkitLineClamp: 2,
                              WebkitBoxOrient: "vertical",
                              overflow: "hidden",
                            }}
                          >
                            {review.comment}
                          </Typography>
                        </Tooltip>
                        <Typography variant="caption" color="text.disabled">
                          {review.craftsmanName} · {review.service}
                        </Typography>
                      </Box>
                    </Box>
                    {idx < MOCK_RECENT_REVIEWS.length - 1 && <Divider sx={{ mt: 1.2 }} />}
                  </Box>
                ))}
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
        </>
      )}
    </Box>
  );
};

export default Home;