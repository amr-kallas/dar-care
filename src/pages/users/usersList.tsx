import { keys, queries } from "@apis/user/queries";
import type { IAdminUser } from "@apis/user/type";
import RemoveIconButton from "@components/buttons/RemoveIconButton";
import RemoveDialog from "@components/forms/RemoveDialog";
import SearchFilter from "@components/inputs/searchFilter";
import ButtonsStack from "@components/layout/buttonStack";
import PaginationTable from "@components/tables/PaginationTable";
import TableRowStriped from "@components/tables/PaginationTable/TableRowStriped";
import useEventSearchParams from "@hooks/useEventSearchParams";
import usePageNumberSearchParam from "@hooks/usePageNumberSearchParam";
import useQuerySearchParam from "@hooks/useQuerySearchParam";
import {
  Grid,
  Stack,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
} from "@mui/material";
import { toisoString } from "@utils/function-helper";
import type { UseInfiniteQueryResult } from "@tanstack/react-query";
import type { APIList } from "../../types/apiType";
import { useEffect } from "react";

const PAGE_SIZE = 10;

const columns = [
  "#",
  "الاسم",
  "رقم الموبايل",
  "البريد الإلكتروني",
  "تاريخ الانشاء",
  "خيارات",
];

const UsersList = () => {
  const search = useQuerySearchParam();
  const { page, clearPageParams } = usePageNumberSearchParam();
  const { remove } = useEventSearchParams();
  const { mutate, isPending } = queries.deleteUser();
  const usersQuery = queries.GetAdminUsers({
    search,
    page,
    per_page: PAGE_SIZE,
  });

  const activeQuery =
    usersQuery as unknown as UseInfiniteQueryResult<APIList<unknown>, unknown>;
  const { data } = activeQuery;

  useEffect(() => {
    clearPageParams();
    // eslint-disable-next-line react-hooks/exhaustive-deps -- mount-only; clearPageParams is not stable
  }, []);

  return (
    <Stack gap={1}>
      <Grid
        container
        spacing={2}
        alignItems="center"
        sx={{ display: "flex", justifyContent: "flex-start" }}
      >
        <Grid item>
          <SearchFilter
            sx={{
              width: "200px",
              input: { paddingY: "12px" },
              marginBottom: "8px",
            }}
          />
        </Grid>
      </Grid>
      <PaginationTable
        pageNumber={page}
        search={search}
        tableHead={
          <TableHead
            sx={{
              ".MuiTableHead-root": {
                color: "red",
              },
            }}
          >
            <TableRow>
              {columns.map((cellHeader, index) => (
                <TableCell
                  key={cellHeader}
                  sx={{
                    ...(index === 0 && {
                      "&.MuiTableCell-root": { pl: 6, textAlign: "center" },
                    }),
                    ".MuiTableSortLabel-root": {
                      color: "white !important",
                    },
                    svg: {
                      color: "white !important",
                    },
                  }}
                >
                  {cellHeader}
                </TableCell>
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
          {(data?.data as IAdminUser[] | undefined)?.map((user, index) => (
            <TableRowStriped key={user.id}>
              <TableCell>{page * PAGE_SIZE + index + 1}</TableCell>
              <TableCell>{user.name}</TableCell>
              <TableCell>{user.phone}</TableCell>
              <TableCell>{user.email}</TableCell>
              <TableCell>
                {user.created_at
                  ? toisoString(new Date(user.created_at)).slice(0, 10)
                  : "_"}
              </TableCell>
              <TableCell>
                <ButtonsStack>
                  <RemoveIconButton
                    onClick={() => remove(String(user.id))}
                  />
                </ButtonsStack>
              </TableCell>
            </TableRowStriped>
          ))}
        </TableBody>
      </PaginationTable>
      <RemoveDialog
        mutateFn={mutate}
        invalidateQueryKey={keys.getAdminUsers._def}
        isPending={isPending}
      />
    </Stack>
  );
};

export default UsersList;
