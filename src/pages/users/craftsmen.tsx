import { keys, queries } from "@apis/provider/queries";
import type {
  IAdminProvider,
  IProviderVerificationStatus,
} from "@apis/provider/type";
import CraftsmanActionsMenu from "@components/buttons/CraftsmanActionsMenu";
import RemoveDialog from "@components/forms/RemoveDialog";
import StopDialog from "@components/forms/StopDialog";
import VerificationDialog from "@components/forms/VerificationDialog";
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
import type {
  UseInfiniteQueryResult,
  UseMutateFunction,
} from "@tanstack/react-query";
import type { APIList } from "../../types/apiType";
import { useEffect } from "react";
import { CraftsmenDetails } from "./craftsmenDetails";

const PAGE_SIZE = 10;
const STOPPED_STATUS = "suspended";
const ACTIVE_STATUS = "available";
const APPROVE_MODE = "approve";
const REJECT_MODE = "reject";

const columns = [
  "#",
  "الاسم",
  "رقم الموبايل",
  "التخصص",
  "تاريخ الانشاء",
  "الحالة",
  "حالة التوثيق",
  "خيارات",
];

function formatCategories(categories: IAdminProvider["categories"]) {
  if (!categories.length) return "_";
  return categories.map((c) => c.name).join("، ");
}

function isProviderActive(status: string) {
  return status === "available";
}

// Approved craftsmen need no further verification action; rejected ones can
// only be approved back.
function canApprove(verificationStatus: IProviderVerificationStatus) {
  return verificationStatus !== "approved";
}

function canReject(verificationStatus: IProviderVerificationStatus) {
  return verificationStatus === "pending";
}

// `busy` is the craftsman switching himself off from the app; `suspended`
// is an admin decision. Both hide him from customers, but only one of them
// the admin can undo, so they must not read the same. Without the `busy`
// case this fell through and printed the raw English word.
function statusLabel(status: string) {
  if (status === "available") return "نشط";
  if (status === "busy") return "غير متاح (أوقفه الحرفي)";
  if (status === "unavailable") return "متوقف";
  if (status === "suspended") return "متوقف (إيقاف إداري)";
  return status;
}

const VERIFICATION_CHIP: Record<
  IProviderVerificationStatus,
  { label: string; color: "success" | "error" | "default" }
> = {
  approved: { label: "مقبول", color: "success" },
  rejected: { label: "مرفوض", color: "error" },
  pending: { label: "قيد المراجعة", color: "default" },
};

function verificationChip(status: IProviderVerificationStatus) {
  return VERIFICATION_CHIP[status] ?? { label: "_", color: "default" as const };
}

const Craftsmen = () => {
  const search = useQuerySearchParam();
  const { page, clearPageParams } = usePageNumberSearchParam();
  const { remove, details, stop } = useEventSearchParams();
  const { stop: activate } = useEventSearchParams({ stopKey: "activate" });
  const { stop: approve } = useEventSearchParams({ stopKey: APPROVE_MODE });
  const { stop: reject } = useEventSearchParams({ stopKey: REJECT_MODE });

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
  const { mutate: updateVerification, isPending: isVerificationPending } =
    queries.updateProviderVerification();

  // VerificationDialog passes { id, rejection_reason }, so bind the target
  // verification status here and forward the dialog's callbacks unchanged.
  const setVerification =
    (
      verification_status: IProviderVerificationStatus,
    ): UseMutateFunction<
      unknown,
      Error,
      { id: string; rejection_reason?: string },
      unknown
    > =>
    (variables, options) =>
      updateVerification(
        { ...variables, verification_status },
        {
          onSuccess: (data, _variables, context) =>
            options?.onSuccess?.(data, variables, context),
          onError: (error, _variables, context) =>
            options?.onError?.(error, variables, context),
        },
      );

  // StopDialog mutates by id only, so bind the target status here and forward
  // its callbacks with the id as the reported variables.
  const setStatus =
    (status: string): UseMutateFunction<unknown, Error, string, unknown> =>
    (id, options) =>
      updateStatus(
        { id, status },
        {
          onSuccess: (data, _variables, context) =>
            options?.onSuccess?.(data, id, context),
          onError: (error, _variables, context) =>
            options?.onError?.(error, id, context),
        },
      );

  const activeQuery = providersQuery as unknown as UseInfiniteQueryResult<
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
                  <Chip
                    label={statusLabel(row.status)}
                    color="success"
                    size="small"
                  />
                ) : (
                  <Chip
                    label={statusLabel(row.status)}
                    color="warning"
                    size="small"
                  />
                )}
              </TableCell>
              <TableCell>
                <Chip
                  label={verificationChip(row.verification_status).label}
                  color={verificationChip(row.verification_status).color}
                  size="small"
                />
              </TableCell>
              <TableCell>
                <ButtonsStack>
                  <CraftsmanActionsMenu
                    isActive={isProviderActive(row.status)}
                    showApprove={canApprove(row.verification_status)}
                    showReject={canReject(row.verification_status)}
                    onDetails={() => details(String(row.id))}
                    onStop={() => stop(String(row.id))}
                    onActivate={() => activate(String(row.id))}
                    onApprove={() => approve(String(row.id))}
                    onReject={() => reject(String(row.id))}
                    onRemove={() => remove(String(row.id))}
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
        mutateFn={setStatus(STOPPED_STATUS)}
        invalidateQueryKey={keys.getAdminProviders._def}
        isPending={isStopPending}
      />
      <StopDialog
        stopModeKey="activate"
        title="هل أنت متأكد من تفعيل هذا الحرفي؟"
        confirmLabel="تفعيل"
        successMessage="تم التفعيل بنجاح"
        confirmColor="success"
        mutateFn={setStatus(ACTIVE_STATUS)}
        invalidateQueryKey={keys.getAdminProviders._def}
        isPending={isStopPending}
      />
      <VerificationDialog
        modeKey={APPROVE_MODE}
        title="هل أنت متأكد من قبول هذا الحرفي؟"
        confirmLabel="قبول"
        successMessage="تم قبول الحرفي بنجاح"
        confirmColor="success"
        mutateFn={setVerification("approved")}
        invalidateQueryKey={keys.getAdminProviders._def}
        isPending={isVerificationPending}
      />
      <VerificationDialog
        modeKey={REJECT_MODE}
        title="هل أنت متأكد من رفض هذا الحرفي؟"
        confirmLabel="رفض"
        successMessage="تم رفض الحرفي بنجاح"
        confirmColor="error"
        requireReason
        mutateFn={setVerification("rejected")}
        invalidateQueryKey={keys.getAdminProviders._def}
        isPending={isVerificationPending}
      />
    </Stack>
  );
};

export default Craftsmen;
