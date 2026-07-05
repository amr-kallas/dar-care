import { keys, queries } from "@apis/user/queries";
import Submit from "@components/buttons/Submit";
import DialogTitle from "@components/forms/dialogTitle";
import TextField from "@components/inputs/textField";
import useAddSubscriptionParams from "@hooks/useAddSubscriptionParams";
import useSuccessSnackbar from "@hooks/useSuccessSnackbar";
import { Dialog, DialogContent, Fade, Grid } from "@mui/material";
import { useQueryClient } from "@tanstack/react-query";
import { FC } from "react";
import { useForm } from "react-hook-form";
import { IAddSubscribtion } from "./validation";
import { useSnackbar } from "@context/snackbarContext";
export type AddFormProps = {};
export const AddSubscription: FC<AddFormProps> = ({}) => {
  const { data } = queries.GetSubscribtion();
  const { mutate, isPending } = queries.AddSubscribtion();
  const queryClient = useQueryClient();
  const { isActive, clearSubscriptionParams } = useAddSubscriptionParams();
  const snackbar = useSnackbar();
  const successSnackbar = useSuccessSnackbar();
  const { control, handleSubmit } = useForm({
    defaultValues: { value: "" },
    values: { value: String(data?.[0]?.value) ?? "" },
  });

  const handleClose = () => {
    clearSubscriptionParams();
  };
  const onSubmit = ({ value }: IAddSubscribtion) => {
    mutate(Number(value), {
      onSuccess: () => {
        queryClient.invalidateQueries();
        handleClose();
        successSnackbar("تم تحديد الاشتراك بنجاح");
      },
      onError: (error) => {
        snackbar({
          message: error.response.data.errorMessage,
          severity: "error",
        });
      },
    });
  };
  return (
    <Dialog open={isActive} onClose={handleClose} fullWidth maxWidth={"sm"}>
      <Fade in={isActive} timeout={0}>
        <DialogTitle onClose={handleClose} fontSize={30} color="primary">
          تحديد الاشتراك
        </DialogTitle>
      </Fade>
      <DialogContent>
        <form onSubmit={handleSubmit(onSubmit)}>
          <Grid
            container
            spacing={3}
            justifyContent={"center"}
            alignItems={"start"}
          >
            <Grid item container spacing={3} xs={10} justifyContent={"center"}>
              <Grid item xs={12} mt={1}>
                <TextField
                  control={control}
                  name="value"
                  label={"السعر "}
                  type="number"
                />
              </Grid>
            </Grid>
            <Grid item xs={12} justifyContent="center" display="flex" mt={0}>
              <Submit isSubmitting={isPending} />
            </Grid>
          </Grid>
        </form>
      </DialogContent>
    </Dialog>
  );
};
