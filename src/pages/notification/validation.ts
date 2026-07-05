import { array, object, string } from "yup";

export type IAddNotification = {
  title: string;
  body: string;
  check: boolean;
  userIds:
    | {
        id: string;
      }[]
    | undefined;
};

export const addNotificationDefaultValue = {
  title: "",
  body: "",
  userIds: undefined,
  check: false,
};

export const addNotificationValidation = (isCheck: boolean) =>
  object().shape({
    title: string().required("هذا الحقل مطلوب"),
    body: string().required("هذا الحقل مطلوب"),
    userIds: isCheck
      ? array()
      : array()
          .of(
            object().shape({
              id: string(),
            })
          )
          .required("هذا الحقل مطلوب")
          .min(1, "هذا الحقل مطلوب"),
  });
