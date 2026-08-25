import { keys, queries } from "@apis/category/queries";
import type { IAdminCategory } from "@apis/category/type";
import Submit from "@components/buttons/Submit";
import DialogTitle from "@components/forms/dialogTitle";
import Checkbox from "@components/inputs/checkBox";
import TextField from "@components/inputs/textField";
import { useSnackbar } from "@context/snackbarContext";
import { yupResolver } from "@hookform/resolvers/yup";
import useAddSearchParams from "@hooks/useAddSearchParams";
import useEditSearchParams from "@hooks/useEditSearchParams";
import useSuccessSnackbar from "@hooks/useSuccessSnackbar";
import { Dialog, DialogContent, Fade, Grid } from "@mui/material";
import { InvalidateQueryFilters, useQueryClient } from "@tanstack/react-query";
import { FC, useEffect } from "react";
import { Resolver, useForm } from "react-hook-form";
import {
  categoryDefaultValue,
  categoryValidation,
  ICategoryForm,
} from "./validation";

function toFormValues(category: IAdminCategory): ICategoryForm {
  return {
    name: category.name,
    description: category.description ?? "",
    is_active: category.is_active == 1,
  };
}

function slugifyName(name: string) {
  return name
    .trim()
    .toLowerCase()
    .replace(/\s+/g, "-")
    .replace(/[^a-z0-9-]/g, "");
}

export const CategoryActions: FC = () => {
  const { isActive, clearAddParams } = useAddSearchParams();
  const { isActive: isEditing, clearEditParams, id } = useEditSearchParams();
  const { data: categories } = queries.GetAdminCategories();

  const { control, reset, handleSubmit } = useForm({
    defaultValues: categoryDefaultValue,
    resolver: yupResolver(
      categoryValidation,
    ) as unknown as Resolver<ICategoryForm>,
  });
  const queryClient = useQueryClient();
  const snackbar = useSnackbar();
  const successSnackbar = useSuccessSnackbar();
  const { mutate, isPending } = queries.saveCategory();

  const handleClose = () => {
    clearAddParams();
    clearEditParams();
    reset(categoryDefaultValue);
  };

  useEffect(() => {
    if (isEditing && id && categories) {
      const category = categories.find((c) => String(c.id) === id);
      if (category) {
        reset(toFormValues(category));
      }
    }
  }, [isEditing, id, categories, reset]);

  const onSubmit = (formData: ICategoryForm) => {
    const existing = isEditing
      ? categories?.find((c) => String(c.id) === id)
      : undefined;
    const body = {
      name: formData.name,
      slug: existing?.slug ?? slugifyName(formData.name),
      icon: existing?.icon ?? "",
      description: formData.description || null,
      is_active: formData.is_active ? 1 : 0,
    };

    mutate(
      { ...body, id: isEditing ? id : undefined },
      {
        onSuccess: () => {
          queryClient.invalidateQueries(
            keys.getAdminCategories._def as InvalidateQueryFilters,
          );
          handleClose();
          successSnackbar(
            isEditing ? "تم تعديل التصنيف بنجاح" : "تم إضافة التصنيف بنجاح",
          );
        },
        onError: (error: { response?: { data?: { message?: string } } }) => {
          snackbar({
            message:
              error.response?.data?.message ?? "حدث خطأ أثناء حفظ التصنيف",
            severity: "error",
          });
        },
      },
    );
  };

  return (
    <Dialog
      open={isActive || isEditing}
      onClose={handleClose}
      fullWidth
      maxWidth="sm"
    >
      <DialogTitle onClose={handleClose}>
        {isEditing ? "تعديل التصنيف" : "تصنيف خدمة جديد"}
      </DialogTitle>
      <DialogContent>
        <Fade in={isActive || isEditing}>
          <form onSubmit={handleSubmit(onSubmit)}>
            <Grid container spacing={2} mt={0.5}>
              <Grid item xs={12}>
                <TextField
                  control={control}
                  name="name"
                  label="الاسم"
                  fullWidth
                  required
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  control={control}
                  name="description"
                  label="الوصف"
                  fullWidth
                  multiline
                  minRows={2}
                />
              </Grid>
              <Grid item xs={12}>
                <Checkbox control={control} name="is_active" label="مفعل" />
              </Grid>
              <Grid item xs={12} display="flex" justifyContent="flex-end">
                <Submit isSubmitting={isPending}>
                  {isEditing ? "حفظ" : "إضافة"}
                </Submit>
              </Grid>
            </Grid>
          </form>
        </Fade>
      </DialogContent>
    </Dialog>
  );
};
