import { createQueryKeys } from "@lukemorales/query-key-factory";
import {
  useInfiniteQuery,
  useMutation,
  useQuery,
} from "@tanstack/react-query";
import API from "./api";
import type {
  IChatMessage,
  IConversation,
  ICursorPage,
  IGetConversationsParams,
} from "./type";

export const keys = createQueryKeys("chat", {
  conversations: (params: IGetConversationsParams) => ({
    queryFn: () => API.getConversations(params),
    queryKey: [params],
  }),
  conversation: (id: number) => ({
    queryFn: () => API.getConversation(id),
    queryKey: [id],
  }),
  messages: (id: number) => ({
    queryFn: () => API.getMessages(id),
    queryKey: [id],
  }),
});

/** Both admin lists are cursor paginated; `next_cursor` is null at the end. */
const nextCursor = <T>(page: ICursorPage<T>) =>
  page.has_more && page.next_cursor ? page.next_cursor : undefined;

export const queries = {
  GetConversations: (params: IGetConversationsParams) =>
    useInfiniteQuery<ICursorPage<IConversation>, Error>({
      queryKey: keys.conversations(params).queryKey,
      queryFn: ({ pageParam }) =>
        API.getConversations({ ...params, cursor: pageParam as string }),
      initialPageParam: undefined as string | undefined,
      getNextPageParam: nextCursor,
    }),

  GetConversation: (id: number) =>
    useQuery({ ...keys.conversation(id), enabled: !!id }),

  /**
   * Messages come back newest-first, so "next page" walks backwards through
   * history — it is the page fetched when the user scrolls up.
   */
  GetMessages: (id: number) =>
    useInfiniteQuery<ICursorPage<IChatMessage>, Error>({
      queryKey: keys.messages(id).queryKey,
      queryFn: ({ pageParam }) => API.getMessages(id, pageParam as string),
      initialPageParam: undefined as string | undefined,
      getNextPageParam: nextCursor,
      enabled: !!id,
    }),

  SendMessage: () => useMutation({ mutationFn: API.sendMessage }),
  MarkRead: () => useMutation({ mutationFn: API.markRead }),
};
