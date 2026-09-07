import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import type {
  IApiEnvelope,
  IChatMessage,
  IConversation,
  ICursorPage,
  IGetConversationsParams,
  ISendMessageBody,
} from "./type";

/** Strips empty filter values so they are not sent as `?type=`. */
const clean = (params: IGetConversationsParams) =>
  Object.fromEntries(
    Object.entries(params).filter(
      ([, value]) => value !== "" && value !== undefined && value !== null
    )
  );

const API = {
  getConversations: async (params: IGetConversationsParams) => {
    const { data } = await axios.get<IApiEnvelope<ICursorPage<IConversation>>>(
      API_ROUTES.CHAT.GET_CONVERSATIONS,
      { params: clean(params) }
    );
    return data.data;
  },

  getConversation: async (id: number) => {
    const { data } = await axios.get<IApiEnvelope<IConversation>>(
      API_ROUTES.CHAT.GET_CONVERSATION(id)
    );
    return data.data;
  },

  getMessages: async (id: number, cursor?: string) => {
    const { data } = await axios.get<IApiEnvelope<ICursorPage<IChatMessage>>>(
      API_ROUTES.CHAT.GET_MESSAGES(id),
      { params: cursor ? { cursor } : undefined }
    );
    return data.data;
  },

  sendMessage: async ({ id, body }: { id: number; body: ISendMessageBody }) => {
    // Never send sender_id / sender_type — the backend derives the sender from
    // the Sanctum token.
    const { data } = await axios.post<IApiEnvelope<IChatMessage>>(
      API_ROUTES.CHAT.SEND_MESSAGE(id),
      body
    );
    return data.data;
  },

  markRead: async ({
    id,
    lastMessageId,
  }: {
    id: number;
    lastMessageId: number | null;
  }) => {
    const { data } = await axios.patch<IApiEnvelope<unknown>>(
      API_ROUTES.CHAT.MARK_READ(id),
      { last_message_id: lastMessageId }
    );
    return data.data;
  },
};

export default API;
