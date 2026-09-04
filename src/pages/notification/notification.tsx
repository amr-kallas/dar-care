import { queries } from "@apis/notification/queries";
import type { INotification } from "@apis/notification/type";
import AddFab from "@components/buttons/addFab";
import SearchFilter from "@components/inputs/searchFilter";
import PaginationTable from "@components/tables/PaginationTable";
import TableRowStriped from "@components/tables/PaginationTable/TableRowStriped";
import usePageNumberSearchParam from "@hooks/usePageNumberSearchParam";
import useQuerySearchParam from "@hooks/useQuerySearchParam";
import {
  Chip,
  Grid,
  Stack,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
} from "@mui/material";
import type { UseInfiniteQueryResult } from "@tanstack/react-query";
import { toisoString } from "@utils/function-helper";
import { useEffect, useMemo } from "react";
import type { APIList } from "../../types/apiType";
import { AddNotification } from "./addNotification";

const PAGE_SIZE = 10;

const columns = ["#", "العنوان", "الوصف", "النوع", "الحالة", "التاريخ"];

const typeLabelMap: Record<string, string> = {
  admin_bulk: "إشعار عام",
  admin_direct: "إشعار مخصص",
};

function typeLabel(type: string) {
  return typeLabelMap[type] ?? type;
}

function formatDateTime(value: string | null) {
  if (!value) return "_";
  return toisoString(new Date(value)).slice(0, 19).replace("T", " ");
}

function buildNotificationPage(
  source: INotification[],
  opts: { query: string; page: number }
): APIList<INotification> {
  const q = opts.query.trim().toLowerCase();
  const rows = source.filter((r) => {
    if (!q) return true;
    return `${r.title} ${r.body}`.toLowerCase().includes(q);
  });
  const totalDataCount = rows.length;
  const totalPages =
    totalDataCount === 0 ? 1 : Math.ceil(totalDataCount / PAGE_SIZE);
  const page = Math.min(Math.max(0, opts.page), Math.max(0, totalPages - 1));
  const start = page * PAGE_SIZE;
  const data = rows.slice(start, start + PAGE_SIZE);
  return { pageNumber: page, totalPages, totalDataCount, data };
}

const Notification = () => {
  const search = useQuerySearchParam();
  const { page, clearPageParams } = usePageNumberSearchParam();

  const notificationsQuery = queries.GetNotifications();

  const list = useMemo(
    () =>
      buildNotificationPage(notificationsQuery.data ?? [], {
        query: search ?? "",
        page,
      }),
    [notificationsQuery.data, search, page]
  );

  const tableQuery = useMemo(
    () =>
      ({
        // Stays undefined until the request resolves — PaginationTable keys its
        // skeleton off a falsy `data`, and `list` is never falsy.
        data: notificationsQuery.data ? list : undefined,
        isFetching: notificationsQuery.isFetching,
        isSuccess: notificationsQuery.isSuccess,
        isError: notificationsQuery.isError,
        fetchNextPage: async () => undefined,
        fetchPreviousPage: async () => undefined,
        refetch: notificationsQuery.refetch,
      }) as unknown as UseInfiniteQueryResult<APIList<unknown>, unknown>,
    [list, notificationsQuery]
  );

  useEffect(() => {
    clearPageParams();
    // eslint-disable-next-line react-hooks/exhaustive-deps -- mount-only reset
  }, []);

  return (
    <Stack gap={1} padding={{ xs: 3, sm: 5 }}>
      <Grid container spacing={2} alignItems="center">
        <Grid item>
          <SearchFilter
            sx={{
              width: "220px",
              input: { paddingY: "12px" },
              marginBottom: "8px",
            }}
            label="البحث"
          />
        </Grid>
      </Grid>

      <PaginationTable
        pageNumber={page}
        search={search}
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
        infiniteQuery={tableQuery}
      >
        <TableBody>
          {(list.data as INotification[]).map((row, index) => (
            <TableRowStriped key={row.id}>
              <TableCell>{page * PAGE_SIZE + index + 1}</TableCell>
              <TableCell>{row.title}</TableCell>
              <TableCell>{row.body}</TableCell>
              <TableCell>{typeLabel(row.type)}</TableCell>
              <TableCell>
                <Chip
                  size="small"
                  color={row.is_read ? "success" : "default"}
                  label={row.is_read ? "مقروءة" : "غير مقروءة"}
                />
              </TableCell>
              <TableCell>{formatDateTime(row.created_at)}</TableCell>
            </TableRowStriped>
          ))}
        </TableBody>
      </PaginationTable>

      <AddFab />
      <AddNotification />
    </Stack>
  );
};

export default Notification;
