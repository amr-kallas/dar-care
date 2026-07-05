import { array, boolean, number, object, string } from "yup";

export type IGenerateQues = {
  //   id?: string;
  matchCount?: number;
  multiChoiceCount?: number;
  trueFalseCount?: number;
  writeCount?: number;
  overRide?: boolean;
};

export const generateQuesDefaultValue = {
  matchCount: undefined,
  multiChoiceCount: undefined,
  trueFalseCount: undefined,
  writeCount: undefined,
  overRide: false,
};

export const generateQuesValidation = object().shape({
  matchCount: number().required("هذا الحقل مطلوب"),
  multiChoiceCount: number().required("هذا الحقل مطلوب"),
  trueFalseCount: number().required("هذا الحقل مطلوب"),
  writeCount: number().required("هذا الحقل مطلوب"),
  overRide: boolean(),
});

export const updateValidations = object().shape({
  title: string().required("العنوان مطلوب"),
  difficulty: number().oneOf([0, 1, 2], "اختر مستوى صعوبة صحيح").required(),
  type: number().oneOf([0, 1, 2, 3], "اختر نوع السؤال").required(),
  matchAnswers: array()
    .of(
      object().shape({
        firstHalf: string().required("الحقل مطلوب"),
        secondHalf: string().required("الحقل مطلوب"),
      })
    )
    .test("conditionalValidation", "الحقل مطلوب", function (value) {
      const { type } = this.parent;
      if (type === 2) {
        return (
          Array.isArray(value) &&
          value.length > 0 &&
          value.every((item) => item.firstHalf && item.secondHalf)
        );
      }
      return true;
    })
    .nullable(),
  multiChoiceAnswers: array()
    .of(
      object().shape({
        title: string()
          .nullable()
        ,
        isCorrect: boolean().default(false),
      })
    )
    .test(
      "conditionalValidation",
      "يجب إدخال 3 خيارات على الأقل، واختيار خيار واحد فقط كإجابة صحيحة",
      function (value) {
        const { type } = this.parent;

        if (type !== 0) return true;
        return Array.isArray(value) &&
          value.filter((item) => item.title?.trim()).length >= 3&&
          value?.filter((item)=>item.isCorrect===true).length===1
      }
    )
    .nullable(),
});
