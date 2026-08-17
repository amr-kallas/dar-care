import { boolean, number, object, string } from "yup";

export type ISendNotificationForm = {
  /** مربّع "إرسال للجميع" — لما يكون مفعّل بينبعت target: "all" */
  toAll: boolean;
  /** بينبعت بس لما يكون toAll = false */
  user_id: number | "";
  title: string;
  message: string;
};

export const sendNotificationDefaultValue: ISendNotificationForm = {
  toAll: false,
  user_id: "",
  title: "",
  message: "",
};

export const sendNotificationValidation = object().shape({
  toAll: boolean().required(),
  user_id: number()
    // السلكت الفاضي بيرجع "" وyup بيعتبرها NaN، فمنحوّلها undefined
    .transform((value, original) =>
      original === "" || original === null ? undefined : value
    )
    .when("toAll", {
      is: false,
      then: (schema) => schema.required("اختر المستخدم"),
      otherwise: (schema) => schema.strip(),
    }),
  title: string().required("هذا الحقل مطلوب"),
  message: string().required("هذا الحقل مطلوب"),
});
