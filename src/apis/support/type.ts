import { IPaginationType } from "../../types/apiType";

export type IGetAllChat = IPaginationType<{
  id: string;
  firstName: string;
  lastName: string;
  dialCode: string;
  phoneNumber: string;
  email: string;
  scanStartDate: string;
  scanEndDate: string;
}>;

export type IGetAllChatParams = Partial<{
  Query: string;
  PageSize: number;
  PageNumber: number;
}>;


export type IGetUserMessage = IPaginationType<{
  id: string;
  message: string;
  fromAdmin: boolean;
  date: string;
}>;

export type IGetAllMessageParams = Partial<{
  PageSize: number;
  PageNumber: number;
  TeacherId: string;
}>;
