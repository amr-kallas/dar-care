import axios from "@lib/axios";
import {
  IGenerateQues,
  IGetAllBooks,
  IGetAllBooksParams,
  IGetAllQues,
  IGetAllQuesParams,
  IGetBook,
  IGetQues,
  IUpdateBook,
  IUpdateQues,
  UploadFormData,
} from "./type";
import API_ROUTES from "@constants/apiRoutes";

const API = {
  uploadFile: async (body: UploadFormData) => {
    const { data } = await axios.post(
      API_ROUTES.QUESTIONS_GENERATOR.UPLOAD_FILE,
      body,
      {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      }
    );
    return data;
  },
  getAllBooks: async (params: IGetAllBooksParams) => {
    const { data } = await axios<IGetAllBooks>(
      API_ROUTES.QUESTIONS_GENERATOR.GET_ALL_BOOKS,
      { params: { ...params, PageNumber: params.PageNumber ?? 0 } }
    );
    return data;
  },
  getBookDetails: async (Id: string) => {
    const { data } = await axios<IGetBook>(
      API_ROUTES.QUESTIONS_GENERATOR.GET_BOOK_DETAILS,
      { params: { Id } }
    );
    return data;
  },
  updateBook: async (body: IUpdateBook) => {
    const { data } = await axios.put(
      API_ROUTES.QUESTIONS_GENERATOR.UPDATE_BOOK,
      body
    );
    return data;
  },
  deleteBook: async (Id: string) => {
    const { data } = await axios.delete(
      API_ROUTES.QUESTIONS_GENERATOR.REMOVE_BOOK,
      { params: { Id } }
    );
    return data;
  },
  generateQues: async (body: IGenerateQues) => {
    const { data } = await axios.post(
      API_ROUTES.QUESTIONS_GENERATOR.GENERATE_QUESTIONS,
      body
    );
    return data;
  },
  getAllQues: async (params: IGetAllQuesParams) => {
    const { data } = await axios<IGetAllQues>(
      API_ROUTES.QUESTIONS_GENERATOR.GET_ALL_QUESTIONS,
      { params }
    );
    return data;
  },
  getQuesDetails: async (Id: string) => {
    const { data } = await axios<IGetQues>(
      API_ROUTES.QUESTIONS_GENERATOR.GET_QUESTION_DETAILS,
      { params: { Id } }
    );
    return data;
  },
  updateQues: async (body: IUpdateQues) => {
    const { data } = await axios.put(
      API_ROUTES.QUESTIONS_GENERATOR.UPDATE_QUESTION,
      body
    );
    return data;
  },
  deleteQues: async (Id: string) => {
    const { data } = await axios.delete(
      API_ROUTES.QUESTIONS_GENERATOR.REMOVE_QUESTION,
      { params: { Id } }
    );
    return data;
  },
};

export default API;
