import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useMutation, useQuery } from "@tanstack/react-query";
import API from "./api";
import { IGetAllBooksParams, IGetAllQuesParams } from "./type";

export const keys = createQueryKeys("GenerateQues", {
  getAllBooks: (params: IGetAllBooksParams) => ({
    queryFn: () => API.getAllBooks(params),
    queryKey: [params],
  }),
  getAllQues: (params: IGetAllQuesParams) => ({
    queryFn: () => API.getAllQues(params),
    queryKey: [params],
  }),
  getBook: (Id: string) => ({
    queryFn: () => API.getBookDetails(Id),
    queryKey: [Id],
  }),
  getQues: (Id: string) => ({
    queryFn: () => API.getQuesDetails(Id),
    queryKey: [Id],
  }),
});

const queries = {
  GetAllBooks: (params: IGetAllBooksParams) =>
    useQuery(keys.getAllBooks(params)),
  GetBook: (Id: string) => useQuery({ ...keys.getBook(Id), enabled: !!Id }),
  GetAllQues: (params: IGetAllQuesParams) => useQuery(keys.getAllQues(params)),
  GetQues: (Id: string) => useQuery({ ...keys.getQues(Id), enabled: !!Id }),
  // UploadFile: () => useMutation({ mutationFn: API.uploadFile }),
  // UpdateBook: () => useMutation({ mutationFn: API.updateBook }),
  BookAction:(id:string)=>useMutation({mutationFn:id?API.updateBook : API.uploadFile}),
  DeleteBook: () => useMutation({ mutationFn: API.deleteBook }),
  GenerateQues: () => useMutation({ mutationFn: API.generateQues }),
  UpdateQues: () => useMutation({ mutationFn: API.updateQues }),
  DeleteQues: () => useMutation({ mutationFn: API.deleteQues }),
};


export default queries