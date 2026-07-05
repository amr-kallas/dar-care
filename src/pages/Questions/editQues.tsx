import queries, { keys } from "@apis/QuesGenerator/query";
import { IGetQues, IUpdateQues } from "@apis/QuesGenerator/type";
import Submit from "@components/buttons/Submit";
import DialogTitle from "@components/forms/dialogTitle";
import { Select } from "@components/inputs/select";
import TextField from "@components/inputs/textField";
import { useSnackbar } from "@context/snackbarContext";
import { yupResolver } from "@hookform/resolvers/yup";
import useEditSearchParams from "@hooks/useEditSearchParams";
import useSuccessSnackbar from "@hooks/useSuccessSnackbar";
import {
  Box,
  Checkbox,
  Dialog,
  DialogContent,
  Fade,
  FormControlLabel,
  Grid,
  MenuItem,
} from "@mui/material";
import { InvalidateQueryFilters, useQueryClient } from "@tanstack/react-query";
import { FC, useEffect } from "react";
import { Controller, useForm } from "react-hook-form";
import { updateValidations } from "./validation";
import Loading from "@components/feedbacks/loading";

type QuestionForm = {
  title: string;
  difficulty: number;
  type: number;
  isCorrect?: boolean;
  multiChoiceAnswers: {
    title: string;
    isCorrect: boolean;
  }[];
  matchAnswers: {
    firstHalf: string;
    secondHalf: string;
  }[];
};

export const EditQues: FC = () => {
  const { id, isActive: isEditing, clearEditParams } = useEditSearchParams();
  const { data, isLoading } = queries.GetQues(id!);
  const queryClient = useQueryClient();
  const snackbar = useSnackbar();
  const successSnackbar = useSuccessSnackbar();
  const { mutate, isPending } = queries.UpdateQues();

  const {
    control,
    handleSubmit,
    reset,
    watch,
    formState: { errors },
  } = useForm<QuestionForm>({
    defaultValues: {
      title: "",
      difficulty: 0,
      type: 0,
      isCorrect: false,
      multiChoiceAnswers: [
        { title: "", isCorrect: false },
        { title: "", isCorrect: false },
        { title: "", isCorrect: false },
        // { title: "", isCorrect: false },
      ],
      matchAnswers: [],
    },
    resolver: yupResolver(updateValidations ),
  });

  const questionType = watch("type");

  useEffect(() => {
    if (data) {
      reset({
        ...data,
        multiChoiceAnswers: data.multiChoiceAnswers?.map((item) => ({
          title: item.title ?? "",
          isCorrect: item.isCorrect ?? false,
        })) ?? [
          { title: null, isCorrect: false },
          { title: null, isCorrect: false },
          { title: null, isCorrect: false },
          // { title: null, isCorrect: false },
        ],
        matchAnswers: data.matchAnswers ?? null,
        isCorrect: data.isCorrect ?? null,
      });
    }
  }, [data, reset, isEditing]);
  const onSubmit = (formData: IGetQues) => {
    mutate(formData, {
      onSuccess: () => {
        queryClient.invalidateQueries(
          keys.getAllQues._def as InvalidateQueryFilters
        );
        successSnackbar("تم التعديل بنجاح");
        clearEditParams();
      },
      onError: (err) => {
        snackbar({ message: err.message, severity: "error" });
      },
    });
  };
console.log(errors)
  return (
    <Dialog open={isEditing} onClose={clearEditParams} fullWidth maxWidth="sm">
      <Fade in={isEditing} timeout={0}>
        <DialogTitle onClose={clearEditParams} fontSize={30}>
          تعديل السؤال
        </DialogTitle>
      </Fade>
      <DialogContent>
        {isLoading ?
          <Box>
          <Loading stackProps={{ sx: { height: "100%" } }} size={90} />
        </Box>:
          <form onSubmit={handleSubmit(onSubmit)}>
          <Grid container spacing={3}>
            <Grid item xs={12}>
              <TextField
                control={control}
                name="title"
                label="العنوان"
                sx={{ marginTop: "10px" }}
                isLoading={isLoading}
              />
            </Grid>

            <Grid item xs={12}>
              <Select control={control} name="difficulty" label="الصعوبة">
                <MenuItem value={0}>سهل</MenuItem>
                <MenuItem value={1}>متوسط</MenuItem>
                <MenuItem value={2}>صعب</MenuItem>
              </Select>
            </Grid>
            <Grid item xs={12}>
              <Select control={control} name="type" label="نوع السؤال">
                <MenuItem value={0}>اختيار من متعدد</MenuItem>
                <MenuItem value={3}>صح أو خطأ</MenuItem>
                <MenuItem value={2}>توصيل</MenuItem>
                <MenuItem value={1}>سؤال كتابي</MenuItem>
              </Select>
            </Grid>

            {questionType === 0 &&
              [0, 1, 2,3].map((index) => (
                <Grid item xs={12} key={index}>
                  <TextField
                    control={control}
                    name={`multiChoiceAnswers.${index}.title`}
                    label={`الاختيار ${index + 1}`}
                  />
                  <FormControlLabel
                    control={
                      <Controller
                        name={`multiChoiceAnswers.${index}.isCorrect`}
                        control={control}
                        defaultValue={false}
                        render={({ field }) => {
                          return (
                            <>
                              <Checkbox
                                checked={
                                  field.value === null ? false : field.value
                                }
                                onChange={(e) =>
                                  field.onChange(e.target.checked)
                                }
                              />
                            </>
                          );
                        }}
                      />
                    }
                    label="إجابة صحيحة"
                  />
                  <p style={{ color: "red" }}>
                    {errors?.multiChoiceAnswers?.root?.message}
                  </p>
                </Grid>
              ))}

            {questionType === 3 && (
              <Grid item xs={12}>
                <FormControlLabel
                  control={
                    <Controller
                      name="isCorrect"
                      control={control}
                      render={({ field }) => (
                        <Checkbox
                          checked={field.value ?? false}
                          onChange={(e) => field.onChange(e.target.checked)}
                        />
                      )}
                    />
                  }
                  label="صح (غير محدد = خطأ)"
                />
              </Grid>
            )}

            {questionType === 2 &&
              [0, 1, 2].map((index) => (
                <Grid item xs={12} key={index}>
                  <TextField
                    control={control}
                    name={`matchAnswers.${index}.firstHalf`}
                    label={`الجزء الأول ${index + 1}`}
                    sx={{ marginBottom: "20px" }}
                  />
                  <TextField
                    control={control}
                    name={`matchAnswers.${index}.secondHalf`}
                    label={`الجزء الثاني ${index + 1}`}
                  />
                </Grid>
              ))}

            <Grid item xs={12} display="flex" justifyContent="center" >
              <Submit isSubmitting={isPending}>تعديل</Submit>
            </Grid>
          </Grid>
        </form>}
      </DialogContent>
    </Dialog>
  );
};
