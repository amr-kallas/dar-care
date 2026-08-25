import { queries } from "@apis/order/queries";
import type { IAdminServiceRequest } from "@apis/order/type";
import ShowIconButton from "@components/buttons/ShowIconButton";
import ButtonsStack from "@components/layout/buttonStack";
import PaginationTable from "@components/tables/PaginationTable";
import TableRowStriped from "@components/tables/PaginationTable/TableRowStriped";
import useEventSearchParams from "@hooks/useEventSearchParams";
import usePageNumberSearchParam from "@hooks/usePageNumberSearchParam";
import useDetailsSearchParams from "@hooks/useDetailsSearchParams";
import {
  Chip,
  Dialog,
  DialogContent,
  Stack,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  Typography,
} from "@mui/material";
import type { UseInfiniteQueryResult } from "@tanstack/react-query";
import type { APIList } from "../../types/apiType";
import { useEffect, useMemo } from "react";
import DialogTitle from "@components/forms/dialogTitle";
import { toisoString } from "@utils/function-helper";

const PAGE_SIZE = 10;

const columns = [
  "#",
  "الحالة",
  "العميل",
  "الحرفي",
  "التصنيف",
  "الأولوية",
  "موعد التنفيذ",
  "تاريخ الإنشاء",
  "خيارات",
];

const statusColorMap: Record<
  string,
  "warning" | "success" | "info" | "error" | "default"
> = {
  pending: "warning",
  completed: "success",
  in_progress: "info",
  accepted: "info",
  cancelled: "error",
};

const statusLabelMap: Record<string, string> = {
  pending: "معلق",
  completed: "مكتمل",
  in_progress: "قيد التنفيذ",
  accepted: "مقبول",
  cancelled: "ملغي",
};

const urgencyLabelMap: Record<string, string> = {
  normal: "عادي",
  urgent: "عاجل",
};

function formatDateTime(value: string | null) {
  if (!value) return "_";
  return toisoString(new Date(value)).slice(0, 19).replace("T", " ");
}

function statusLabel(status: string) {
  return statusLabelMap[status] ?? status;
}

function statusColor(status: string) {
  return statusColorMap[status] ?? "default";
}

function urgencyLabel(urgency: string) {
  return urgencyLabelMap[urgency] ?? urgency;
}

const OrderDetailsDialog = ({ rows }: { rows: IAdminServiceRequest[] }) => {
  const { id, isActive, clearDetailsParams } = useDetailsSearchParams();
  const row = useMemo(() => rows.find((r) => String(r.id) === id), [rows, id]);

  return (
    <Dialog
      open={isActive}
      onClose={clearDetailsParams}
      fullWidth
      maxWidth="sm"
    >
      <DialogTitle onClose={clearDetailsParams}>تفاصيل الطلب</DialogTitle>
      <DialogContent>
        {!row ? (
          <Typography>لا توجد بيانات.</Typography>
        ) : (
          <Stack gap={1}>
            <Typography>رقم الطلب: {row.id}</Typography>
            <Typography>العميل: {row.user.name}</Typography>
            <Typography>الحرفي: {row.provider.name}</Typography>
            <Typography>التصنيف: {row.category.name}</Typography>
            <Typography>الحالة: {statusLabel(row.status)}</Typography>
            <Typography>الأولوية: {urgencyLabel(row.urgency)}</Typography>
            <Typography>الوصف: {row.description || "_"}</Typography>
            <Typography>
              موعد التنفيذ: {formatDateTime(row.scheduled_at)}
            </Typography>
            <Typography>
              تاريخ الإنشاء: {formatDateTime(row.created_at)}
            </Typography>
          </Stack>
        )}
      </DialogContent>
    </Dialog>
  );
};

const Orders = () => {
  const { page, clearPageParams } = usePageNumberSearchParam();
  const { details } = useEventSearchParams();

  const ordersQuery = queries.GetAdminServiceRequests({
    page,
    per_page: PAGE_SIZE,
  });

  const activeQuery = ordersQuery as unknown as UseInfiniteQueryResult<
    APIList<unknown>,
    unknown
  >;
  const { data } = activeQuery;

  useEffect(() => {
    clearPageParams();
    // eslint-disable-next-line react-hooks/exhaustive-deps -- mount-only reset
  }, []);

  return (
    <Stack gap={1} padding={{ xs: 3, sm: 5 }}>
      <PaginationTable
        pageNumber={page}
        tableHead={
          <TableHead>
            <TableRow>
              {columns.map((cellHeader) => (
                <TableCell key={cellHeader}>{cellHeader}</TableCell>
              ))}
            </TableRow>
          </TableHead>
        }
        skeleton={true}
        isInfinite={false}
        cellCount={columns.length}
        infiniteQuery={activeQuery}
      >
        <TableBody>
          {(data?.data as IAdminServiceRequest[] | undefined)?.map(
            (row, index) => (
              <TableRowStriped key={row.id}>
                <TableCell>{page * PAGE_SIZE + index + 1}</TableCell>
                <TableCell>
                  <Chip
                    size="small"
                    color={statusColor(row.status)}
                    label={statusLabel(row.status)}
                  />
                </TableCell>
                <TableCell>{row.user.name}</TableCell>
                <TableCell>{row.provider.name}</TableCell>
                <TableCell>{row.category.name}</TableCell>
                <TableCell>
                  <Chip
                    size="small"
                    color={row.urgency === "urgent" ? "error" : "default"}
                    label={urgencyLabel(row.urgency)}
                    variant="outlined"
                  />
                </TableCell>
                <TableCell>{formatDateTime(row.scheduled_at)}</TableCell>
                <TableCell>{formatDateTime(row.created_at)}</TableCell>
                <TableCell>
                  <ButtonsStack>
                    <ShowIconButton onClick={() => details(String(row.id))} />
                  </ButtonsStack>
                </TableCell>
              </TableRowStriped>
            ),
          )}
        </TableBody>
      </PaginationTable>

      <OrderDetailsDialog rows={(data?.data as IAdminServiceRequest[]) ?? []} />
    </Stack>
  );
};

export default Orders;
