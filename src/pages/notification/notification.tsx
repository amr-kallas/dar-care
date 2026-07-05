import { keys, queries } from "@apis/notification/queries";
import AddFab from "@components/buttons/addFab";
import PaginationTable from "@components/tables/PaginationTable";
import TableRowStriped from "@components/tables/PaginationTable/TableRowStriped";
import usePageNumberSearchParam from "@hooks/usePageNumberSearchParam";
import {
  Stack,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
} from "@mui/material";
import { AddNotification } from "./addNotification";
import { useEffect } from "react";
import RemoveIconButton from "@components/buttons/RemoveIconButton";
import ButtonsStack from "@components/layout/buttonStack";
import useEventSearchParams from "@hooks/useEventSearchParams";
import RemoveDialog from "@components/forms/RemoveDialog";

const columns = ["العنوان", "الوصف", "الحالة", "التاريخ", "خيارات"];

const Notification = () => {
  const query = queries.GetAllNotification({});
  const { mutate, isPending } = queries.DeleteNotification();
  const { data } = query;
  const { page, clearPageParams } = usePageNumberSearchParam();
  const { remove } = useEventSearchParams();

  useEffect(() => {
    clearPageParams();
  }, []);
  return (
    <Stack gap={1} padding={{ xs: 3, sm: 5 }}>
      <PaginationTable
        pageNumber={page}
        tableHead={
          <TableHead>
            <TableRow>
              {columns.map((cellHeader, index) => (
                <TableCell
                  key={cellHeader}
                  sx={{
                    ...(index === 0 && {
                      "&.MuiTableCell-root": { pl: 6, textAlign: "center" },
                    }),
                  }}
                >
                  {cellHeader}
                </TableCell>
              ))}
            </TableRow>
          </TableHead>
        }
        skeleton={true}
        cellCount={columns.length}
        infiniteQuery={query}
      >
        <TableBody>
          {data?.pages[page]?.data?.map((notification) => {
            return (
              <TableRowStriped key={notification.id}>
                <TableCell>{notification.title}</TableCell>
                <TableCell>{notification.body}</TableCell>
                <TableCell>
                  {notification.isRead ? "مقروءة" : "غير مقروءة"}{" "}
                </TableCell>
                <TableCell>
                  {notification.date.split("T")[0].slice(0, 16)}{" "}
                </TableCell>
                <TableCell>
                  <ButtonsStack>
                    <RemoveIconButton onClick={() => remove(notification.id)} />
                  </ButtonsStack>
                </TableCell>
              </TableRowStriped>
            );
          })}
        </TableBody>
      </PaginationTable>
      <AddFab />
      <AddNotification />
      <RemoveDialog
        mutateFn={mutate}
        invalidateQueryKey={keys.getAllNotification._def}
        isPending={isPending}
      />
    </Stack>
  );
};

export default Notification;
