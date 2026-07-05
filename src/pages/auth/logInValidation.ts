import { object, string } from "yup";

export type ILoginForm = {
  userName: string;
  password: string;
};

export const LoginDefaultValues = {
  userName: "",
  password: "",
};

export const loginValidation = object().shape({
  userName: string().required("هذا الحقل مطلوب"),
  password: string().required("هذا الحقل مطلوب").min(6, "على الأقل 6 حروف"),
});
