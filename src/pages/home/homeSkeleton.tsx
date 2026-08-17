import React from "react";
import { Box, Card, CardContent, Divider, Grid, Skeleton } from "@mui/material";

const CARD_SX = {
  borderRadius: 3,
  border: "1px solid",
  borderColor: "grey.200",
  height: "100%",
} as const;

const SectionHeaderSkeleton = () => (
  <Box display="flex" alignItems="center" gap={1} mb={2.5} justifyContent="flex-end">
    <Skeleton variant="rounded" width={4} height={24} />
    <Skeleton variant="circular" width={20} height={20} />
    <Skeleton variant="text" width={140} height={28} />
  </Box>
);

const KpiCardSkeleton = () => (
  <Card elevation={0} sx={{ ...CARD_SX, height: "auto" }}>
    <CardContent sx={{ p: 2.5 }}>
      <Box display="flex" justifyContent="space-between" mb={1.5}>
        <Box flexGrow={1}>
          <Skeleton variant="text" width="60%" height={20} />
          <Skeleton variant="text" width="40%" height={38} />
        </Box>
        <Skeleton variant="rounded" width={46} height={46} />
      </Box>
    </CardContent>
  </Card>
);

/** Rows of an avatar + two stacked text lines, used by the artisan/rating lists. */
const ListRowsSkeleton = ({ rows = 5 }: { rows?: number }) => (
  <Box display="flex" flexDirection="column" gap={1.5}>
    {Array.from({ length: rows }).map((_, idx) => (
      <Box key={idx}>
        <Box display="flex" alignItems="center" gap={1.2}>
          <Skeleton variant="circular" width={34} height={34} />
          <Box flexGrow={1}>
            <Skeleton variant="text" width="45%" height={20} />
            <Skeleton variant="text" width="65%" height={16} />
          </Box>
          <Skeleton variant="text" width={32} height={20} />
        </Box>
        {idx < rows - 1 && <Divider sx={{ mt: 1.2 }} />}
      </Box>
    ))}
  </Box>
);

const HomeSkeleton: React.FC = () => (
  <>
    <Grid container spacing={2.2} mb={3}>
      {Array.from({ length: 4 }).map((_, idx) => (
        <Grid item xs={12} sm={6} lg={3} key={idx}>
          <KpiCardSkeleton />
        </Grid>
      ))}
    </Grid>

    <Grid container spacing={2.5} mb={3}>
      <Grid item xs={12} lg={8}>
        <Card elevation={0} sx={CARD_SX}>
          <CardContent sx={{ p: 2.5 }}>
            <SectionHeaderSkeleton />
            <Skeleton variant="rounded" width="100%" height={280} />
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} sm={6} lg={4}>
        <Card elevation={0} sx={CARD_SX}>
          <CardContent sx={{ p: 2.5 }}>
            <SectionHeaderSkeleton />
            <Box display="grid" sx={{ placeItems: "center" }}>
              <Skeleton variant="circular" width={156} height={156} />
            </Box>
            <Box mt={2} display="flex" flexDirection="column" gap={1}>
              {Array.from({ length: 5 }).map((_, idx) => (
                <Box key={idx} display="flex" alignItems="center" gap={1}>
                  <Skeleton variant="circular" width={10} height={10} />
                  <Skeleton variant="text" sx={{ flexGrow: 1 }} height={16} />
                  <Skeleton variant="text" width={36} height={16} />
                </Box>
              ))}
            </Box>
          </CardContent>
        </Card>
      </Grid>
    </Grid>

    <Grid container spacing={2.5} mb={3}>
      <Grid item xs={12} md={6}>
        <Card elevation={0} sx={CARD_SX}>
          <CardContent sx={{ p: 2.5 }}>
            <SectionHeaderSkeleton />
            <Box display="flex" flexDirection="column" gap={1.3}>
              {Array.from({ length: 5 }).map((_, idx) => (
                <Box key={idx} display="flex" alignItems="center" gap={1.5}>
                  <Skeleton variant="text" width={36} height={20} />
                  <Skeleton variant="rounded" sx={{ flexGrow: 1 }} height={8} />
                  <Skeleton variant="text" width={60} height={16} />
                </Box>
              ))}
            </Box>
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} md={6}>
        <Card elevation={0} sx={CARD_SX}>
          <CardContent sx={{ p: 2.5 }}>
            <SectionHeaderSkeleton />
            <Skeleton variant="rounded" width="100%" height={210} />
          </CardContent>
        </Card>
      </Grid>
    </Grid>

    <Grid container spacing={2.5}>
      <Grid item xs={12}>
        <Card elevation={0} sx={{ ...CARD_SX, height: "auto" }}>
          <CardContent sx={{ p: 2.5, pb: 1 }}>
            <SectionHeaderSkeleton />
          </CardContent>
          <Box px={2.5} pb={2.5}>
            <Skeleton variant="rounded" height={38} sx={{ mb: 1 }} />
            {Array.from({ length: 5 }).map((_, idx) => (
              <Skeleton key={idx} variant="text" height={40} />
            ))}
          </Box>
        </Card>
      </Grid>
    </Grid>

    <Grid container spacing={2.5} sx={{ mt: 0 }}>
      <Grid item xs={12} md={6}>
        <Card elevation={0} sx={CARD_SX}>
          <CardContent sx={{ p: 2.5 }}>
            <SectionHeaderSkeleton />
            <ListRowsSkeleton />
          </CardContent>
        </Card>
      </Grid>
      <Grid item xs={12} md={6}>
        <Card elevation={0} sx={CARD_SX}>
          <CardContent sx={{ p: 2.5 }}>
            <SectionHeaderSkeleton />
            <ListRowsSkeleton />
          </CardContent>
        </Card>
      </Grid>
    </Grid>
  </>
);

export default HomeSkeleton;
