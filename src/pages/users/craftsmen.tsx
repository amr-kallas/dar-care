import { keys, queries } from "@apis/provider/queries";
import type { IAdminProvider } from "@apis/provider/type";
import RemoveIconButton from "@components/buttons/RemoveIconButton";
import ShowIconButton from "@components/buttons/ShowIconButton";
import StopIconButton from "@components/buttons/StopIconButton";
import RemoveDialog from "@components/forms/RemoveDialog";
import StopDialog from "@components/forms/StopDialog";
import SearchFilter from "@components/inputs/searchFilter";
import ButtonsStack from "@components/layout/buttonStack";
import PaginationTable from "@components/tables/PaginationTable";
import TableRowStriped from "@components/tables/PaginationTable/TableRowStriped";
import useEventSearchParams from "@hooks/useEventSearchParams";
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
import { toisoString } from "@utils/function-helper";
import type { UseInfiniteQueryResult } from "@tanstack/react-query";
import type { APIList } from "../../types/apiType";
import { useEffect } from "react";
import { CraftsmenDetails } from "./craftsmenDetails";

const PAGE_SIZE = 10;
const STOPPED_STATUS = "suspended";

const columns = [
  "#",
  "الاسم",
  "رقم الموبايل",
  "التخصص",
  "تاريخ الانشاء",
  "الحالة",
  "خيارات",
];

function formatCategories(categories: IAdminProvider["categories"]) {
  if (!categories.length) return "_";
  return categories.map((c) => c.name).join("، ");
}

function isProviderActive(status: string) {
  return status === "available";
}

function statusLabel(status: string) {
  if (status === "available") return "نشط";
  if (status === "unavailable") return "متوقف";
  return status;
}

const Craftsmen = () => {
  const search = useQuerySearchParam();
  const { page, clearPageParams } = usePageNumberSearchParam();
  const { remove, details, stop } = useEventSearchParams();

  const providersQuery = queries.GetAdminProviders({
    status: "",
    search,
    page,
    per_page: PAGE_SIZE,
  });

  const { mutate: deleteProvider, isPending: isDeletePending } =
    queries.deleteAdminProvider();
  const { mutate: updateStatus, isPending: isStopPending } =
    queries.updateProviderStatus();

  const activeQuery =
    providersQuery as unknown as UseInfiniteQueryResult<
      APIList<unknown>,
      unknown
    >;
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
        isInfinite={false}
        cellCount={columns.length}
        infiniteQuery={activeQuery}
      >
        <TableBody>
          {(data?.data as IAdminProvider[] | undefined)?.map((row, index) => (
            <TableRowStriped key={row.id}>
              <TableCell>{page * PAGE_SIZE + index + 1}</TableCell>
              <TableCell>{row.name}</TableCell>
              <TableCell>{row.phone}</TableCell>
              <TableCell>{formatCategories(row.categories)}</TableCell>
              <TableCell>
                {row.created_at
                  ? toisoString(new Date(row.created_at)).slice(0, 10)
                  : "_"}
              </TableCell>
              <TableCell>
                {isProviderActive(row.status) ? (
                  <Chip label={statusLabel(row.status)} color="success" size="small" />
                ) : (
                  <Chip label={statusLabel(row.status)} color="warning" size="small" />
                )}
              </TableCell>
              <TableCell>
                <ButtonsStack>
                  <ShowIconButton
                    onClick={() => details(String(row.id))}
                  />
                  <RemoveIconButton
                    onClick={() => remove(String(row.id))}
                  />
                  <StopIconButton
                    disabled={!isProviderActive(row.status)}
                    onClick={() => stop(String(row.id))}
                  />
                </ButtonsStack>
              </TableCell>
            </TableRowStriped>
          ))}
        </TableBody>
      </PaginationTable>
      <CraftsmenDetails records={(data?.data as IAdminProvider[]) ?? []} />
      <RemoveDialog
        mutateFn={deleteProvider}
        invalidateQueryKey={keys.getAdminProviders._def}
        isPending={isDeletePending}
      />
      <StopDialog
        mutateFn={(id, options) =>
          updateStatus({ id, status: STOPPED_STATUS }, options)
        }
        invalidateQueryKey={keys.getAdminProviders._def}
        isPending={isStopPending}
      />
    </Stack>
  );
};

export default Craftsmen;
