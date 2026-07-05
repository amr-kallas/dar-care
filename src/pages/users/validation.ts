import { dialCodes } from "@static/static-data";
import { object, string } from "yup";

export type IAddUser = {
  firstName: string;
  lastName: string;
  phoneNumber: string;
  gender: string;
  dialCode: {
    id: string;
    label: string;
    flag: string;
    code: string;
  };
  scanType: string;

};

export type IAddSubscribtion = {
  value: string;
};

export const addUserDefaultValue = {
  firstName: "",
  lastName: "",
  phoneNumber: "",
  gender: "",
  dialCode: dialCodes[0],
  scanType:""
};

export const addUserValidation = object().shape({
  firstName: string().required("هذا الحقل مطلوب"),
  lastName: string().required("هذا الحقل مطلوب"),
  phoneNumber: string().required("هذا الحقل مطلوب").min(9, "على الأقل 9 أرقام"),
  gender: string().required("هذا الحقل مطلوب"),
  scanType: string().required("هذا الحقل مطلوب"),

  dialCode: object()
    .shape({
      id: string(),
      code: string(),
      label: string(),
      flag: string(),
    })
    .test({
      message: "هذا الحقل مطلوب",
      test: ({ id }) => {
        return !!id;
      },
    }),
});
