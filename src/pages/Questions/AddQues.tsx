import Submit from "@components/buttons/Submit";
import DialogTitle from "@components/forms/dialogTitle";
import TextField from "@components/inputs/textField";
import { yupResolver } from "@hookform/resolvers/yup";
import useAddSearchParams from "@hooks/useAddSearchParams";
import useSuccessSnackbar from "@hooks/useSuccessSnackbar";
import {
    Dialog,
    DialogContent,
    Fade,
    Grid
} from "@mui/material";
import { InvalidateQueryFilters, useQueryClient } from "@tanstack/react-query";
import { FC } from "react";
import { Resolver, useForm } from "react-hook-form";
// import { IAddUser, addUserDefaultValue, addUserValidation } from "./validation";
import queries, { keys } from "@apis/QuesGenerator/query";
import classQueries from "@apis/class/query";
import Checkbox from "@components/inputs/checkBox";
import { useSnackbar } from "@context/snackbarContext";
import { useParams } from "react-router-dom";
import { generateQuesDefaultValue, generateQuesValidation, IGenerateQues } from "./validation";

export type AddFormProps = {};
export const AddQues: FC<AddFormProps> = ({ }) => {
    const { id } = useParams();
  const { isActive, clearAddParams } = useAddSearchParams();
  const {
    control,

    reset,
    handleSubmit,
  } = useForm({
    defaultValues: generateQuesDefaultValue,
    resolver: yupResolver(generateQuesValidation) as unknown as Resolver<IGenerateQues>,
  });

  const queryClient = useQueryClient();
  const snackbar = useSnackbar();
  const successSnackbar = useSuccessSnackbar();

  // const { mutate, isPending } = queries.UploadFile();
  const { mutate, isPending } = queries.GenerateQues();
  const handleClose = () => {
    clearAddParams();
    reset(generateQuesDefaultValue);
  };

  const onSubmit = async (data: IGenerateQues) => {
    const body = {
      ...data,
      id,
      };
      console.log(body)
    mutate(body, {
      onSuccess: () => {
        queryClient.invalidateQueries(
          keys.getAllBooks._def as InvalidateQueryFilters
        );
        handleClose();
        successSnackbar("تم اضافة اسئلة بنجاح");
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
          {"توليد اسئلة"}
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
                  name="matchCount"
                  type="number"
                  label={"اسئلة التوصيل"}
                  //   isLoading={isLoading}
                />
              </Grid>
              <Grid item xs={12} mt={1}>
                <TextField
                  control={control}
                  name="multiChoiceCount"
                  type="number"
                  label={"اسئلة الاختيار من متعدد"}
                  //   isLoading={isLoading}
                />
              </Grid>
              <Grid item xs={12} mt={1}>
                <TextField
                  control={control}
                  name="trueFalseCount"
                  type="number"
                  label={"اسئلة الصح والخطأ"}
                  //   isLoading={isLoading}
                />
              </Grid>
              <Grid item xs={12} mt={1}>
                <TextField
                  control={control}
                  name="writeCount"
                  type="number"
                  label={"الاسئلة الكتابية"}
                  //   isLoading={isLoading}
                />
              </Grid>
              <Grid item xs={12} mt={1}>
                <Checkbox
                  control={control}
                  name="overRide"
                  label="توليد اسئلة جديدة "
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
