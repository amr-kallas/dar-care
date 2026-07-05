import { keys, queries } from "@apis/user/queries";
import Submit from "@components/buttons/Submit";
import DialogTitle from "@components/forms/dialogTitle";
import AutocompleteControl from "@components/inputs/autoComplete";
import { Select } from "@components/inputs/select";
import TextField from "@components/inputs/textField";
import { yupResolver } from "@hookform/resolvers/yup";
import useAddSearchParams from "@hooks/useAddSearchParams";
import useSuccessSnackbar from "@hooks/useSuccessSnackbar";
import PersonIcon from "@mui/icons-material/Person";
import {
  Autocomplete,
  Dialog,
  DialogContent,
  Fade,
  Grid,
  InputAdornment,
  MenuItem,
} from "@mui/material";
import { dialCodes } from "@static/static-data";
import { InvalidateQueryFilters, useQueryClient } from "@tanstack/react-query";
import { FC} from "react";
import { Resolver, useForm } from "react-hook-form";
import { IAddUser, addUserDefaultValue, addUserValidation } from "./validation";
import { useSnackbar } from "@context/snackbarContext";
export type AddFormProps = {};
export const AddUser: FC<AddFormProps> = ({}) => {
  const { isActive, clearAddParams } = useAddSearchParams();
  const { control, reset, handleSubmit } =
   useForm({
    defaultValues: addUserDefaultValue,
    resolver: yupResolver(addUserValidation) as unknown as Resolver<IAddUser>,
  });
  
  const queryClient = useQueryClient();
  const snackbar = useSnackbar();
  const successSnackbar = useSuccessSnackbar();
  const { mutate, isPending } = queries.AddUser();
  const handleClose = () => {
    clearAddParams();
    reset(addUserDefaultValue);
  };

  const onSubmit = async (data: IAddUser) => {
    const body = {
      ...data,
      gender: Number(data.gender),
      dialCode: data.dialCode.id,
      scanType:Number(data.scanType)
    };

    mutate(body, {
      onSuccess: () => {
        queryClient.invalidateQueries(
          keys.getUsers._def as InvalidateQueryFilters
        );
        handleClose();
        successSnackbar("تم إضافة المستخدم بنجاح");
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
          إضافة مستخدم
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
                  name="firstName"
                  InputProps={{
                    endAdornment: (
                      <InputAdornment position="end">
                        <PersonIcon />
                      </InputAdornment>
                    ),
                  }}
                  label={"الاسم الاول"}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  control={control}
                  name="lastName"
                  InputProps={{
                    endAdornment: (
                      <InputAdornment position="end">
                        <PersonIcon />
                      </InputAdornment>
                    ),
                  }}
                  label={"الاسم الاخير"}
                />
              </Grid>
              <Grid sx={{ display: "flex" }} item xs={12}>
                <Grid item xs={12}>
                  <TextField
                    control={control}
                    name="phoneNumber"
                    label={"رقم الهاتف"}
                    sx={{
                      ".MuiOutlinedInput-notchedOutline": {
                        borderRight: "none !important",
                        borderBottomRightRadius: 0,
                        borderTopRightRadius: 0,
                      },
                    }}
                  />
                </Grid>
                <Grid item xs={6}>
                  <AutocompleteControl
                    control={control}
                    label={"رمز الدولة"}
                    name={"dialCode"}
                    required={false}
                  >
                    <Autocomplete
                      options={dialCodes ?? []}
                      getOptionLabel={(option) => option.id}
                      renderInput={() => null}
                      sx={{
                        ".MuiOutlinedInput-notchedOutline": {
                          borderBottomLeftRadius: 0,
                          borderTopLeftRadius: 0,
                        },
                      }}
                      renderOption={(props, option) => (
                        <li {...props} key={option.flag}>
                          {option.flag}
                          {option.label} {option.id}
                        </li>
                      )}
                    />
                  </AutocompleteControl>
                </Grid>
              </Grid>
              <Grid item xs={12}>
                <Select control={control} name="gender" label={"الجنس"}>
                  <MenuItem value={"1"}>ذكر</MenuItem>
                  <MenuItem value={"2"}>أنثى</MenuItem>
                </Select>
              </Grid>
              <Grid item xs={12}>
                <Select control={control} name="scanType" label={"نوع المسح"}>
                  <MenuItem value={0}>مجاني</MenuItem>
                  <MenuItem value={1}>مدفوع</MenuItem>
                </Select>
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
