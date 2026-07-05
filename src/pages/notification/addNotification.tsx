import { keys, queries } from "@apis/notification/queries";
import { queries as userQuery } from "@apis/user/queries";
import Submit from "@components/buttons/Submit";
import DialogTitle from "@components/forms/dialogTitle";
import AutocompleteControl from "@components/inputs/autoComplete";
import Checkbox from "@components/inputs/checkBox";
import TextField from "@components/inputs/textField";
import { useSnackbar } from "@context/snackbarContext";
import { yupResolver } from "@hookform/resolvers/yup";
import useAddSearchParams from "@hooks/useAddSearchParams";
import useSuccessSnackbar from "@hooks/useSuccessSnackbar";
import { Autocomplete, Dialog, DialogContent, Fade, Grid } from "@mui/material";
import { InvalidateQueryFilters, useQueryClient } from "@tanstack/react-query";
import { FC, useState } from "react";
import { Resolver, useForm } from "react-hook-form";
import {
  IAddNotification,
  addNotificationDefaultValue,
  addNotificationValidation,
} from "./validation";
export type AddFormProps = {};
export const AddNotification: FC<AddFormProps> = ({}) => {
  const [isCheck, setIsCheck] = useState(false);

  const { isActive, clearAddParams } = useAddSearchParams();
  const { control, handleSubmit, reset, setValue } = useForm({
    defaultValues: addNotificationDefaultValue,
    resolver: yupResolver(
      addNotificationValidation(isCheck)
    ) as unknown as Resolver<IAddNotification>,
  });

  const queryClient = useQueryClient();
  const snackbar = useSnackbar();
  const successSnackbar = useSuccessSnackbar();
  const { data: allUser } = userQuery.GetAllUsers({ PageSize: 0 });
  const { mutate, isPending } = queries.SendNotification();
  const handleClose = () => {
    clearAddParams();
    reset(addNotificationDefaultValue);
  };
  const onSubmit = async (data: IAddNotification) => {
    const body = {
      userIds: (!isCheck
        ? data?.userIds?.map(({ id }) => id)
        : allUser?.data.map(({ id }) => id) ?? []) as string[],
      title: {
        en: data.title,
        ar: data.title,
      },
      body: {
        en: data.body,
        ar: data.body,
      },
    };
    mutate(body, {
      onSuccess: () => {
        queryClient.invalidateQueries(
          keys.getAllNotification._def as InvalidateQueryFilters
        );
        handleClose();
        successSnackbar("تم إرسال الإشعار بنجاح");
      },
      onError: (error) => {
        snackbar({
          message: error.response.data.errorMessage,
          severity: "error",
        });
      },
    });
  };

  const changeValue = (check: boolean) => {
    setIsCheck(check);
    if (check) {
      setValue("userIds", []);
    }
  };

  return (
    <Dialog open={isActive} onClose={handleClose} fullWidth maxWidth={"sm"}>
      <Fade in={isActive} timeout={0}>
        <DialogTitle onClose={handleClose} fontSize={30} color="primary">
          إرسال إشعار
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
              <Grid item xs={12}>
                <AutocompleteControl
                  control={control}
                  label={"المرسل إليه"}
                  name={"userIds"}
                  required={false}
                  disabled={isCheck}
                >
                  <Autocomplete
                    options={allUser?.data ?? []}
                    getOptionLabel={(option) => option.firstName}
                    renderInput={() => null}
                    multiple
                    sx={{ mt: "6px" }}
                    renderOption={(props, option) => (
                      <li
                        {...props}
                        key={option.id}
                        style={{
                          borderBottom: "1px solid #ddd",
                          padding: "12px 8px",
                        }}
                      >
                        {option.firstName}
                      </li>
                    )}
                  />
                </AutocompleteControl>
                <Checkbox
                  onChangeValue={changeValue}
                  control={control}
                  name="check"
                  label="تحديد كل المستخدمين"
                  sx={{
                    ".MuiFormControlLabel-root": {
                      marginRight: "0px !important",
                    },
                  }}
                />
              </Grid>
              <Grid item xs={12} mt={1}>
                <TextField control={control} name="title" label={"العنوان"} />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  control={control}
                  name="body"
                  multiline
                  rows={5}
                  label={"الوصف"}
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
