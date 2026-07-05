import { queries } from "@apis/rating/queries";
import type { IAdminRating } from "@apis/rating/type";
import ShowIconButton from "@components/buttons/ShowIconButton";
import ButtonsStack from "@components/layout/buttonStack";
import PaginationTable from "@components/tables/PaginationTable";
import TableRowStriped from "@components/tables/PaginationTable/TableRowStriped";
import useEventSearchParams from "@hooks/useEventSearchParams";
import usePageNumberSearchParam from "@hooks/usePageNumberSearchParam";
import useDetailsSearchParams from "@hooks/useDetailsSearchParams";
import {
  Dialog,
  DialogContent,
  Rating,
  Stack,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  Typography,
} from "@mui/material";
import type { UseInfiniteQueryResult } from "@tanstack/react-query";
import { useEffect, useMemo } from "react";
import type { APIList } from "../../types/apiType";
import DialogTitle from "@components/forms/dialogTitle";
import { toisoString } from "@utils/function-helper";

const PAGE_SIZE = 10;

const columns = [
  "#",
  "المقيّم",
  "الحرفي",
  "رقم الطلب",
  "التقييم",
  "تاريخ الإنشاء",
  "خيارات",
];

const ReviewDetailsDialog = ({ rows }: { rows: IAdminRating[] }) => {
  const { id, isActive, clearDetailsParams } = useDetailsSearchParams();
  const row = useMemo(
    () => rows.find((r) => String(r.id) === id),
    [rows, id]
  );

  return (
    <Dialog open={isActive} onClose={clearDetailsParams} fullWidth maxWidth="sm">
      <DialogTitle onClose={clearDetailsParams}>تفاصيل التقييم</DialogTitle>
      <DialogContent>
        {!row ? (
          <Typography>لا توجد بيانات.</Typography>
        ) : (
          <Stack gap={1}>
            <Typography>المقيّم: {row.user.name}</Typography>
            <Typography>الحرفي: {row.provider.name}</Typography>
            <Typography>رقم الطلب: {row.service_request_id}</Typography>
            <Typography>
              التقييم: <Rating value={row.rating} readOnly size="small" />
            </Typography>
            <Typography>التعليق: {row.comment || "_"}</Typography>
            <Typography>
              تاريخ الإنشاء:{" "}
              {row.created_at
                ? toisoString(new Date(row.created_at)).slice(0, 19).replace("T", " ")
                : "_"}
            </Typography>
          </Stack>
        )}
      </DialogContent>
    </Dialog>
  );
};

const Reviews = () => {
  const { page, clearPageParams } = usePageNumberSearchParam();
  const { details } = useEventSearchParams();

  const ratingsQuery = queries.GetAdminRatings({
    rating: "",
    provider_id: "",
    page,
    per_page: PAGE_SIZE,
  });

  const activeQuery =
    ratingsQuery as unknown as UseInfiniteQueryResult<APIList<unknown>, unknown>;
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
          {(data?.data as IAdminRating[] | undefined)?.map((row, index) => (
            <TableRowStriped key={row.id}>
              <TableCell>{page * PAGE_SIZE + index + 1}</TableCell>
              <TableCell>{row.user.name}</TableCell>
              <TableCell>{row.provider.name}</TableCell>
              <TableCell>{row.service_request_id}</TableCell>
              <TableCell>
                <Rating size="small" value={row.rating} readOnly />
              </TableCell>
              <TableCell>
                {row.created_at
                  ? toisoString(new Date(row.created_at)).slice(0, 19).replace("T", " ")
                  : "_"}
              </TableCell>
              <TableCell>
                <ButtonsStack>
                  <ShowIconButton
                    onClick={() => details(String(row.id))}
                  />
                </ButtonsStack>
              </TableCell>
            </TableRowStriped>
          ))}
        </TableBody>
      </PaginationTable>

      <ReviewDetailsDialog rows={(data?.data as IAdminRating[]) ?? []} />
    </Stack>
  );
};

export default Reviews;
