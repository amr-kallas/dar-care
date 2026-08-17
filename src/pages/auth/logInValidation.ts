import { object, string } from "yup";

export type ILoginForm = {
  email: string;
  password: string;
};

export const LoginDefaultValues: ILoginForm = {
  email: "",
  password: "",
};

export const loginValidation = object().shape({
  email: string()
    .email("البريد الإلكتروني غير صالح")
    .required("هذا الحقل مطلوب"),
  password: string().required("هذا الحقل مطلوب").min(6, "على الأقل 6 حروف"),
});
