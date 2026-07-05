import { APIList } from "../../types/apiType";

export type IGetAllBooksParams = Partial<{
  Query: string;
  PageSize: number;
  PageNumber: number;
}>;
export type IGetBook = {
  id: string;
  createdAt: string; // ISO date string
  title: string;
  country: string;
  classId: string;
  className: string;
  pageCount: number;
  matchCount: number;
  multiChoiceCount: number;
  trueFalseCount: number;
  writeCount: number;
  language: string; 
};
export type IGetAllBooks = APIList<IGetBook>;
export type IUpdateBook = {
  id?: string;
  title: string;
  country: string;
  classId: string;
  language: number;
};


export type IGenerateQues = {
  id?: string;
  matchCount?: number;
  multiChoiceCount?: number;
  trueFalseCount?: number;
  writeCount?: number;
  overRide?: boolean;
};

export type IGetAllQuesParams = Partial<{
  Difficulty: number;
  Type: number;
  BookId: string;
  Query: string;
  PageSize: number;
  PageNumber: number;
}>;

export type IGetQues = {
  id: string;
  title: string;
  pageNumber: number;
  difficulty: number;
  type: number;
  bookId: string;
  bookTitle: string;
  isCorrect: boolean;
  multiChoiceAnswers: {
    title: string;
    isCorrect: boolean;
  }[];
  matchAnswers: {
    firstHalf: string;
    secondHalf: string;
  }[];
};
export type IGetAllQues = APIList<IGetQues>;

export type IUpdateQues = IGetQues & { id: string }

export type UploadFormData = {
  file?: File;
  title: string;
  country: string;
  classId: string;
  language: number;
};