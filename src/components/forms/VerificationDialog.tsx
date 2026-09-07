import useStopSearchParams from "@hooks/useStopSearchParams";
import useSuccessSnackbar from "@hooks/useSuccessSnackbar";
import { yupResolver } from "@hookform/resolvers/yup";
import { DialogContent } from "@mui/material";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import { Stack } from "@mui/system";
import {
  InvalidateQueryFilters,
  UseMutateFunction,
  useQueryClient,
} from "@tanstack/react-query";
import { FC, useEffect } from "react";
import { useForm } from "react-hook-form";
import { object, string } from "yup";
import TextField from "../inputs/textField";
import Loading from "../feedbacks/loading";
import DialogTitle from "./dialogTitle";

export type IVerificationForm = {
  rejection_reason: string;
};

const rejectionValidation = object().shape({
  rejection_reason: string()
    .trim()
    .required("هذا الحقل مطلوب")
    .max(1000, "الحد الأقصى 1000 حرف"),
});

type MutateVariables = { id: string; rejection_reason?: string };

type Props = {
  invalidateQueryKey?: readonly string[];
  mutateFn: UseMutateFunction<unknown, Error, MutateVariables, unknown>;
  isPending: boolean;
  /** URL `mode` value that opens this dialog. */
  modeKey: string;
  title: string;
  confirmLabel: string;
  successMessage: string;
  confirmColor: "success" | "error";
  /**
   * Rejection requires a reason on the API side, so the dialog collects one
   * before it will submit.
   */
  requireReason?: boolean;
};

const VerificationDialog: FC<Props> = ({
  mutateFn,
  invalidateQueryKey,
  isPending,
  modeKey,
  title,
  confirmLabel,
  successMessage,
  confirmColor,
  requireReason = false,
}) => {
  const queryClient = useQueryClient();
  const { id, isActive, clearStopParams } = useStopSearchParams("id", modeKey);
  const successSnackbar = useSuccessSnackbar();

  const { control, handleSubmit, reset } = useForm<IVerificationForm>({
    defaultValues: { rejection_reason: "" },
    resolver: yupResolver(rejectionValidation),
  });

  // Drop the previous craftsman's reason when the dialog is reopened.
  useEffect(() => {
    if (isActive) reset({ rejection_reason: "" });
  }, [isActive, reset]);

  const handleClose = () => {
    clearStopParams();
  };

  const submit = (values?: IVerificationForm) => {
    mutateFn(
      {
        id: id ?? "",
        ...(requireReason
          ? { rejection_reason: values?.rejection_reason?.trim() }
          : {}),
      },
      {
        onSuccess: () => {
          if (invalidateQueryKey?.length) {
            queryClient.invalidateQueries(
              invalidateQueryKey as InvalidateQueryFilters
            );
          }
          successSnackbar(successMessage);
          handleClose();
        },
      }
    );
  };

  const handleConfirm = requireReason
    ? handleSubmit((values) => submit(values))
    : () => submit();

  return (
    <Dialog open={isActive} onClose={handleClose} fullWidth maxWidth="xs">
      <Stack component="form" noValidate>
        <DialogTitle onClose={handleClose}>{title}</DialogTitle>
        {/* overflowX hidden: the themed scrollbar is green and shows up as a
            stray bar whenever the field's focus ring overflows by a pixel. */}
        <DialogContent sx={{ overflowX: "hidden" }}>
          {requireReason && (
            <TextField
              control={control}
              name="rejection_reason"
              label="سبب الرفض"
              required
              multiline
              minRows={3}
              sx={{ mt: 1 }}
            />
          )}
          {isPending && <Loading />}
        </DialogContent>
        <DialogActions>
          <Button
            onClick={handleClose}
            sx={{
              color: "primary.main",
              bgcolor: "white",
              border: "1px solid",
              borderColor: "primary.main",
              "&:hover": {
                bgcolor: "primary.main",
                color: "white",
              },
            }}
          >
            إلغاء
          </Button>
          <Button
            onClick={handleConfirm}
            disabled={isPending}
            sx={{
              bgcolor: `${confirmColor}.main`,
              color: "white",
              "&:hover": {
                bgcolor: `${confirmColor}.dark`,
                color: "white",
              },
            }}
          >
            {confirmLabel}
          </Button>
        </DialogActions>
      </Stack>
    </Dialog>
  );
};

export default VerificationDialog;
