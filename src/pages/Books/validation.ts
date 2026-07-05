import { IGetBook } from "@apis/QuesGenerator/type";
import { object, string } from "yup";

export type IAddBook = {
  title?: string;
  country?: string;
//   file?: string;
  classId?: {id:string,name:string};
  language?:string;
};



export const addBookDefaultValue = {
  title: "",
  country: "",
  classId: {id:'' , name:''},
//   file: "",
  language:'',
};

export const addBookValidation = object().shape({
 title: string().required("هذا الحقل مطلوب"),
  country: string().required("هذا الحقل مطلوب"),
  classId:  
              object().shape({
                id: string(),
                name:string()
              })
            
            .required("هذا الحقل مطلوب"),
  language: string().required("هذا الحقل مطلوب"),
//   file: string().required("هذا الحقل مطلوب"),
});


export const boodValues = (data:IGetBook) => {
  if (data)
    return {
      country: data.country,
      classId:{id:data.classId , name:data.className},
      title: data.title,
      language: data.language,
    };
}