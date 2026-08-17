import useStopSearchParams from "@hooks/useStopSearchParams";
import useSuccessSnackbar from "@hooks/useSuccessSnackbar";
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
import { FC } from "react";
import Loading from "../feedbacks/loading";
import DialogTitle from "./dialogTitle";

type Props = {
  invalidateQueryKey?: readonly string[];
  mutateFn: UseMutateFunction<unknown, Error, string, unknown>;
  isPending: boolean;
  /** URL `mode` value that opens this dialog (default: stop). */
  stopModeKey?: string;
  title?: string;
  confirmLabel?: string;
  successMessage?: string;
  /** Palette key used for the confirm button (default: warning). */
  confirmColor?: "warning" | "success";
};

const StopDialog: FC<Props> = ({
  mutateFn,
  invalidateQueryKey,
  isPending,
  stopModeKey = "stop",
  title = "هل أنت متأكد من إيقاف هذا الحرفي؟",
  confirmLabel = "إيقاف",
  successMessage = "تم الإيقاف بنجاح",
  confirmColor = "warning",
}) => {
  const queryClient = useQueryClient();
  const { id, isActive, clearStopParams } = useStopSearchParams(
    "id",
    stopModeKey
  );
  const successSnackbar = useSuccessSnackbar();

  const handleClose = () => {
    clearStopParams();
  };

  const handleStop = () => {
    mutateFn(id ?? "", {
      onSuccess: () => {
        if (invalidateQueryKey?.length) {
          queryClient.invalidateQueries(
            invalidateQueryKey as InvalidateQueryFilters
          );
        }
        successSnackbar(successMessage);
        handleClose();
      },
    });
  };

  return (
    <form>
      <Dialog open={isActive} onClose={handleClose}>
        <Stack width={500} maxWidth="100%">
          <DialogTitle onClose={handleClose}>{title}</DialogTitle>
          <DialogContent>{isPending && <Loading />}</DialogContent>
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
              onClick={handleStop}
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
    </form>
  );
};
export default StopDialog;
