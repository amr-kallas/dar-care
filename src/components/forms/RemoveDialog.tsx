import useRemoveSearchParams from "@hooks/useRemoveSearchParams";
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
  invalidateQueryKey: readonly string[];
  mutateFn: UseMutateFunction<any, Error, string, unknown>;
  isPending: boolean;
  /** URL `mode` value that opens this dialog (default: remove). */
  removeModeKey?: string;
};
const RemoveDialog: FC<Props> = ({
  mutateFn,
  invalidateQueryKey,
  isPending,
  removeModeKey = "remove",
}) => {
  const queryClient = useQueryClient();
  const { id, isActive, clearRemoveParams } = useRemoveSearchParams(
    "id",
    removeModeKey
  );
  const successSnackbar = useSuccessSnackbar();

  const handleClose = () => {
    clearRemoveParams();
  };

  const handleRemove = () => {
    mutateFn(id ?? "", {
      onSuccess: () => {
        queryClient.invalidateQueries(
          invalidateQueryKey as InvalidateQueryFilters
        );
        successSnackbar("تم الحذف بنجاح");
        handleClose();
      },
    });
  };
  return (
    <form>
      <Dialog open={isActive} onClose={handleClose}>
        <Stack width={500} maxWidth="100%">
          <DialogTitle onClose={handleClose}>
            هل أنت متأكد من أنك تريد الحذف
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
              onClick={handleRemove}
              disabled={isPending}
              sx={{
                bgcolor: "error.main",
                color: "white",
                "&:hover": {
                  bgcolor: "error.main",
                  color: "white",
                },
              }}
            >
              حذف
            </Button>
          </DialogActions>
        </Stack>
      </Dialog>
    </form>
  );
};
export default RemoveDialog;
