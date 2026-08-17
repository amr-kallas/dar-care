import { keys, queries } from "@apis/notification/queries";
import { queries as userQueries } from "@apis/user/queries";
import Submit from "@components/buttons/Submit";
import DialogTitle from "@components/forms/dialogTitle";
import Checkbox from "@components/inputs/checkBox";
import TextField from "@components/inputs/textField";
import { useSnackbar } from "@context/snackbarContext";
import { yupResolver } from "@hookform/resolvers/yup";
import useAddSearchParams from "@hooks/useAddSearchParams";
import useSuccessSnackbar from "@hooks/useSuccessSnackbar";
import { Dialog, DialogContent, Fade, Grid, MenuItem } from "@mui/material";
import { InvalidateQueryFilters, useQueryClient } from "@tanstack/react-query";
import { FC } from "react";
import { Resolver, useForm, useWatch } from "react-hook-form";
import {
  ISendNotificationForm,
  sendNotificationDefaultValue,
  sendNotificationValidation,
} from "./validation";

/** كبيرة عن قصد حتى تنزل كل المستخدمين بطلب واحد للسلكت. */
const USERS_PAGE_SIZE = 1000;

export const AddNotification: FC = () => {
  const { isActive, clearAddParams } = useAddSearchParams();

  const { control, handleSubmit, reset, setValue } = useForm({
    defaultValues: sendNotificationDefaultValue,
    resolver: yupResolver(
      sendNotificationValidation,
    ) as unknown as Resolver<ISendNotificationForm>,
  });

  const toAll = useWatch({ control, name: "toAll" });

  const { data: usersPage, isLoading: usersLoading } =
    userQueries.GetAdminUsers({
      search: "",
      page: 0,
      per_page: USERS_PAGE_SIZE,
    });
  const users = usersPage?.data ?? [];

  const queryClient = useQueryClient();
  const snackbar = useSnackbar();
  const successSnackbar = useSuccessSnackbar();
  const { mutate, isPending } = queries.SendBulkNotification();

  const handleClose = () => {
    clearAddParams();
    reset(sendNotificationDefaultValue);
  };

  const onSubmit = (formData: ISendNotificationForm) => {
    // "all" ما بيروح معها user_id، و"specific" لازم يروح معها.
    const payload = formData.toAll
      ? {
          target: "all" as const,
          title: formData.title,
          message: formData.message,
        }
      : {
          target: "specific" as const,
          user_id: Number(formData.user_id),
          title: formData.title,
          message: formData.message,
        };

    mutate(payload, {
      onSuccess: () => {
        queryClient.invalidateQueries(
          keys.getNotifications._def as InvalidateQueryFilters,
        );
        handleClose();
        successSnackbar("تم إرسال الإشعار بنجاح");
      },
      onError: (error: { response?: { data?: { message?: string } } }) => {
        snackbar({
          message:
            error.response?.data?.message ?? "حدث خطأ أثناء إرسال الإشعار",
          severity: "error",
        });
      },
    });
  };

  return (
    <Dialog open={isActive} onClose={handleClose} fullWidth maxWidth="sm">
      <DialogTitle onClose={handleClose}>إرسال إشعار</DialogTitle>
      <DialogContent>
        <Fade in={isActive}>
          <form onSubmit={handleSubmit(onSubmit)}>
            <Grid container spacing={2} mt={0.5}>
              <Grid item xs={12}>
                <TextField
                  control={control}
                  name="user_id"
                  label="المستخدم"
                  select
                  fullWidth
                  disabled={toAll || usersLoading}
                  required={!toAll}
                  helperText={
                    usersLoading ? "جارٍ تحميل المستخدمين..." : undefined
                  }
                >
                  {users.map((user) => (
                    <MenuItem key={user.id} value={user.id}>
                      {user.name}
                    </MenuItem>
                  ))}
                </TextField>
              </Grid>
              <Grid item xs={12}>
                <Checkbox
                  control={control}
                  name="toAll"
                  label="إرسال لكل المستخدمين"
                  checked={toAll}
                  onChangeValue={(checked) => {
                    // تفريغ الاختيار حتى ما ينبعت user_id قديم بالغلط
                    if (checked) setValue("user_id", "");
                  }}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  control={control}
                  name="title"
                  label="العنوان"
                  fullWidth
                  required
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  control={control}
                  name="message"
                  label="الوصف"
                  fullWidth
                  multiline
                  rows={5}
                  required
                />
              </Grid>
              <Grid item xs={12} display="flex" justifyContent="flex-end">
                <Submit isSubmitting={isPending}>إرسال</Submit>
              </Grid>
            </Grid>
          </form>
        </Fade>
      </DialogContent>
    </Dialog>
  );
};
