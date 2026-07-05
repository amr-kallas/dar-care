import { IPaginationType } from "../../types/apiType";

export type IGetAllNotification = IPaginationType<{
  id: string;
  title: string;
  body: string;
  isRead: boolean;
  date: string;
}>;

export type IGetAllNotificationParams = Partial<{
  PageSize: number;
  PageNumber: number;
}>;

export type ISendNotification = {
  userIds: string[];
  title: {
    en: string;
    ar: string;
  };
  body: {
    en: string;
    ar: string;
  };
};
