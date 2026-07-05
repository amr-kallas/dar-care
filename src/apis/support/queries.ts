import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useInfiniteQuery } from "@tanstack/react-query";
import API from "./api";
import {
  IGetAllChat,
  IGetAllChatParams,
  IGetAllMessageParams,
  IGetUserMessage,
} from "./type";
import { APIList } from "../../types/apiType";

export const keys = createQueryKeys("user", {
  getChats: (params: IGetAllChatParams) => ({
    queryFn: () => API.getAllChat(params),
    queryKey: [params],
  }),
  getChatsUser: (params: IGetAllMessageParams) => ({
    queryFn: () => API.getChatsUser(params),
    queryKey: [params],
  }),
});

export const queries = {
  GetAllChat: (params: IGetAllChatParams) =>
    useInfiniteQuery<APIList<IGetAllChatParams>, Error, IGetAllChat>({
      queryKey: [params],

      queryFn: ({ pageParam = 0 }) => {
        return API.getAllChat({
          ...params,
          PageNumber: pageParam as number,
          
        });
        
      },

      getNextPageParam: (lastPage) => {
        const currentPage = lastPage.pageNumber;
        const totalPages = lastPage.totalPages;

        return currentPage < totalPages - 1 ? currentPage + 1 : undefined;
      },
      getPreviousPageParam: (firstPage) => {
        const currentPage = firstPage.pageNumber;
        return currentPage > 0 ? currentPage - 1 : undefined;
      },
     

    }),

  GetChatsUser: (params: IGetAllMessageParams) =>
    useInfiniteQuery<APIList<IGetAllMessageParams>, Error, IGetUserMessage>({
      queryKey: [params],
      queryFn: ({ pageParam = 0 }) => {
        return API.getChatsUser({
          ...params,
          PageNumber: pageParam as number,
          PageSize: 25,
        });
      },
      getNextPageParam: (lastPage) => {
        const currentPage = lastPage.pageNumber;
        const totalPages = lastPage.totalPages;
        return currentPage < totalPages - 1 ? currentPage + 1 : undefined;
      },
      
          getPreviousPageParam: (firstPage) => {
        const currentPage = firstPage.pageNumber;
        return currentPage > 0 ? currentPage - 1 : undefined;
      },
      enabled: !!params.TeacherId,
      
    }),
};




