import * as yup from "yup";

export type ICategoryForm = {
  name: string;
  description: string;
  is_active: boolean;
};

export const categoryDefaultValue: ICategoryForm = {
  name: "",
  description: "",
  is_active: true,
};

export const categoryValidation = yup.object({
  name: yup.string().required("الاسم مطلوب"),
  description: yup.string(),
  is_active: yup.boolean(),
});
