import Submit from "@components/buttons/Submit";
import DialogTitle from "@components/forms/dialogTitle";
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
import { InvalidateQueryFilters, useQueryClient } from "@tanstack/react-query";
import { FC, useEffect } from "react";
import { Resolver, useForm } from "react-hook-form";
// import { IAddUser, addUserDefaultValue, addUserValidation } from "./validation";
import queries, { keys } from "@apis/QuesGenerator/query";
import classQueries from "@apis/class/query";
import { FileInput } from "@components/inputs/FileInput";
import AutocompleteControl from "@components/inputs/autoComplete";
import { useSnackbar } from "@context/snackbarContext";
import useEditSearchParams from "@hooks/useEditSearchParams";
import {
  addBookDefaultValue,
  addBookValidation,
  boodValues,
  IAddBook,
} from "./validation";
export type AddFormProps = {};
export const BookSAction: FC<AddFormProps> = ({}) => {
  const { isActive, clearAddParams } = useAddSearchParams();
  const { isActive: isEditing, clearEditParams, id } = useEditSearchParams();
  const { data: classes } = classQueries.GetAllClass({ Filter: true });
  const { data, isLoading} = queries.GetBook(id!);
  const {
    control,

    reset,
    handleSubmit,
  } = useForm({
    defaultValues: addBookDefaultValue,
    resolver: yupResolver(addBookValidation) as unknown as Resolver<IAddBook>,
  });

  const queryClient = useQueryClient();
  const snackbar = useSnackbar();
  const successSnackbar = useSuccessSnackbar();

  // const { mutate, isPending } = queries.UploadFile();
  const { mutate, isPending} = queries.BookAction(id!);
  const handleClose = () => {
    clearAddParams();
    clearEditParams();
    reset(addBookDefaultValue);
  };

  useEffect(() => {
    if (isEditing && data) {
      reset(boodValues(data));
    }
  }, [isEditing, data, reset]);
  const onSubmit = async (data: IAddBook) => {
    console.log(data)
    const body = {
      ...data,
      language: Number(data.language),
      classId: data.classId?.id,
      id,
    };
    mutate(body, {
      onSuccess: () => {
        queryClient.invalidateQueries(
          keys.getAllBooks._def as InvalidateQueryFilters
        );
        handleClose();
        successSnackbar(id?"تم تعديل الكتاب بنجاح":"تم اضافة كتاب بنجاح");
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
    <Dialog
      open={isActive || isEditing}
      onClose={handleClose}
      fullWidth
      maxWidth={"sm"}
    >
      <Fade in={isActive || isEditing} timeout={0}>
        <DialogTitle onClose={handleClose} fontSize={30} color="primary">
          {isActive ? "اضافة كتب" : "تعديل كتاب"}
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
                  name="title"
                  label={"العنوان"}
                  isLoading={isLoading}
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  control={control}
                  name="country"
                  isLoading={isLoading}
                  InputProps={{
                    endAdornment: (
                      <InputAdornment position="end">
                        <PersonIcon />
                      </InputAdornment>
                    ),
                  }}
                  label={"البلد"}
                />
              </Grid>
              <Grid item xs={12}>
                <FileInput
                  control={control}
                  name="file"
                  label="الملف"
                  disabled={isEditing}
                />
              </Grid>
              <Grid item xs={12}>
                <AutocompleteControl
                  control={control}
                  label={"الصف"}
                  name={"classId"}
                  required={false}
                  isLoading={isLoading}
                >
                  <Autocomplete
                    options={classes ?? []}
                    getOptionLabel={(option) => option?.name || ""}
                    isOptionEqualToValue={(option, value) =>
                      option.id === value?.id
                    }
                    renderInput={(params) => (
                      <TextField {...params} label="الصف" />
                    )}
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
                        {option.name}
                      </li>
                    )}
                  />
                </AutocompleteControl>
              </Grid>

              <Grid item xs={12}>
                <Select
                  control={control}
                  name="language"
                  label={"اللغة"}
                  isLoading={isLoading}
                >
                  <MenuItem value={"0"}>العربية</MenuItem>
                  <MenuItem value={"1"}>الانجليزية</MenuItem>
                </Select>
              </Grid>
            </Grid>

            <Grid item xs={12} justifyContent="center" display="flex" mt={0}>
              <Submit isSubmitting={isPending}>{id ? "تعديل" : "إضافة"}</Submit>
            </Grid>
          </Grid>
        </form>
      </DialogContent>
    </Dialog>
  );
};
