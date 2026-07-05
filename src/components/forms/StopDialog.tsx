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
};

const StopDialog: FC<Props> = ({
  mutateFn,
  invalidateQueryKey,
  isPending,
  stopModeKey = "stop",
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
        successSnackbar("تم الإيقاف بنجاح");
        handleClose();
      },
    });
  };

  return (
    <form>
      <Dialog open={isActive} onClose={handleClose}>
        <Stack width={500} maxWidth="100%">
          <DialogTitle onClose={handleClose}>
            هل أنت متأكد من إيقاف هذا الحرفي؟
          </DialogTitle>
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
                bgcolor: "warning.main",
                color: "white",
                "&:hover": {
                  bgcolor: "warning.dark",
                  color: "white",
                },
              }}
            >
              إيقاف
            </Button>
          </DialogActions>
        </Stack>
      </Dialog>
    </form>
  );
};
export default StopDialog;
