import { keys, queries } from "@apis/category/queries";
import type { IAdminCategory } from "@apis/category/type";
import EditIconButton from "@components/buttons/EditIconButton";
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
  Button,
  Chip,
  Grid,
  Stack,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
} from "@mui/material";
import type { UseInfiniteQueryResult } from "@tanstack/react-query";
import type { APIList } from "../../types/apiType";
import { useEffect, useMemo } from "react";
import { useSearchParams } from "react-router-dom";
import { CategoryActions } from "./categoryActions";

const PAGE_SIZE = 10;

const columns = [
  "#",
  "الاسم",
  "مفعل",
  "عدد الحرفيين",
  "خيارات",
];

function buildCategoryPage(
  source: IAdminCategory[],
  opts: { query: string; page: number }
): APIList<IAdminCategory> {
  const q = opts.query.trim().toLowerCase();
  const rows = source.filter((r) => {
    if (!q) return true;
    return `${r.name} ${r.description ?? ""}`
      .toLowerCase()
      .includes(q);
  });
  const totalDataCount = rows.length;
  const totalPages =
    totalDataCount === 0 ? 1 : Math.ceil(totalDataCount / PAGE_SIZE);
  const page = Math.min(Math.max(0, opts.page), Math.max(0, totalPages - 1));
  const start = page * PAGE_SIZE;
  const data = rows.slice(start, start + PAGE_SIZE);
  return { pageNumber: page, totalPages, totalDataCount, data };
}

const ServiceCategories = () => {
  const search = useQuerySearchParam();
  const { page, clearPageParams } = usePageNumberSearchParam();
  const { edit, remove } = useEventSearchParams();
  const [, setSearchParams] = useSearchParams();

  const categoriesQuery = queries.GetAdminCategories();
  const { mutate: deleteCategory, isPending: isDeletePending } =
    queries.deleteCategory();

  const list = useMemo(
    () =>
      buildCategoryPage(categoriesQuery.data ?? [], {
        query: search ?? "",
        page,
      }),
    [categoriesQuery.data, search, page]
  );

  const tableQuery = useMemo(
    () =>
      ({
        // Stays undefined until the request resolves — PaginationTable keys its
        // skeleton off a falsy `data`, and `list` is never falsy.
        data: categoriesQuery.data ? list : undefined,
        isFetching: categoriesQuery.isFetching,
        isSuccess: categoriesQuery.isSuccess,
        isError: categoriesQuery.isError,
        fetchNextPage: async () => undefined,
        fetchPreviousPage: async () => undefined,
        refetch: categoriesQuery.refetch,
      }) as unknown as UseInfiniteQueryResult<APIList<unknown>, unknown>,
    [list, categoriesQuery]
  );

  const handleAdd = () => {
    setSearchParams((params) => {
      params.set("mode", "add");
      return params;
    });
  };

  useEffect(() => {
    clearPageParams();
    // eslint-disable-next-line react-hooks/exhaustive-deps -- mount-only reset
  }, []);

  return (
    <Stack gap={1} padding={{ xs: 3, sm: 5 }}>
      <Grid container spacing={2} justifyContent="space-between" alignItems="center">
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
        <Grid item>
          <Button variant="contained" color="warning" onClick={handleAdd}>
            تصنيف خدمة جديد
          </Button>
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
          {(list.data as IAdminCategory[]).map((row, index) => (
            <TableRowStriped key={row.id}>
              <TableCell>{page * PAGE_SIZE + index + 1}</TableCell>
              <TableCell>{row.name}</TableCell>
              <TableCell>
                <Chip
                  size="small"
                  color={row.is_active === 1 ? "success" : "default"}
                  label={row.is_active === 1 ? "نعم" : "لا"}
                />
              </TableCell>
              <TableCell>{row.providers_count}</TableCell>
              <TableCell>
                <ButtonsStack>
                  <EditIconButton
                    onClick={() => edit(String(row.id))}
                  />
                  <RemoveIconButton
                    onClick={() => remove(String(row.id))}
                  />
                </ButtonsStack>
              </TableCell>
            </TableRowStriped>
          ))}
        </TableBody>
      </PaginationTable>

      <CategoryActions />
      <RemoveDialog
        mutateFn={deleteCategory}
        invalidateQueryKey={keys.getAdminCategories._def}
        isPending={isDeletePending}
      />
    </Stack>
  );
};

export default ServiceCategories;
