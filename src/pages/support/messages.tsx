import { keys, queries } from "@apis/chat/queries";
import type { IChatMessageView } from "@apis/chat/type";
import Skeleton from "@components/feedbacks/skeleton";
import { useSnackbar } from "@context/snackbarContext";
import {
  useConversationChannel,
  usePusherReconnect,
} from "@hooks/useChatChannels";
import { getAdminId } from "@lib/session";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import LockOutlinedIcon from "@mui/icons-material/LockOutlined";
import RefreshIcon from "@mui/icons-material/Refresh";
import SendIcon from "@mui/icons-material/Send";
import {
  Alert,
  AppBar,
  Avatar,
  Box,
  Button,
  Chip,
  IconButton,
  Stack,
  TextField,
  Toolbar,
  Tooltip,
  Typography,
} from "@mui/material";
import { useTheme } from "@mui/material/styles";
import { useQueryClient } from "@tanstack/react-query";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import { SUPPORT_PATH } from "../../routes/path";
import {
  CONVERSATION_TYPE_LABEL,
  canAdminSend,
  counterpartName,
  eventToMessage,
  formatTime,
  isOwnMessage,
  isSupport,
  mergeMessages,
  messageKey,
  newClientMessageId,
} from "./chatHelpers";

const Messages = () => {
  const { id = "" } = useParams();
  const conversationId = Number(id);
  const navigate = useNavigate();
  const theme = useTheme();
  const snackbar = useSnackbar();
  const queryClient = useQueryClient();
  const adminId = getAdminId();

  const [draft, setDraft] = useState("");
  /** Optimistic sends plus broadcasts that the REST pages have not caught up to. */
  const [local, setLocal] = useState<IChatMessageView[]>([]);
  const [sendBlockedUntil, setSendBlockedUntil] = useState(0);

  const scrollRef = useRef<HTMLDivElement | null>(null);
  const stickToBottom = useRef(true);

  const conversationQuery = queries.GetConversation(conversationId);
  const conversation = conversationQuery.data;

  const {
    data,
    isLoading,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
    refetch,
  } = queries.GetMessages(conversationId);

  const sendMessage = queries.SendMessage();
  const markRead = queries.MarkRead();

  const serverMessages = useMemo(
    () => (data?.pages ?? []).flatMap((page) => page.data),
    [data]
  );

  const messages = useMemo(
    () => mergeMessages(serverMessages, local),
    [serverMessages, local]
  );

  const composerEnabled = canAdminSend(conversation);
  const lastMessageId = serverMessages.length
    ? Math.max(...serverMessages.map((message) => message.id))
    : null;

  // Reset per-conversation local state when navigating between threads.
  useEffect(() => {
    setLocal([]);
    setDraft("");
    stickToBottom.current = true;
  }, [conversationId]);

  /**
   * Events are ShouldBroadcastNow, so a broadcast can land before the POST that
   * caused it resolves. Merging by key makes arrival order irrelevant.
   */
  useConversationChannel(
    Number.isFinite(conversationId) && conversationId ? conversationId : null,
    useCallback((event) => {
      setLocal((prev) => mergeMessages([eventToMessage(event)], prev));
    }, [])
  );

  // No "messages since id" endpoint exists, so resync by refetching and deduping.
  usePusherReconnect(
    useCallback(() => {
      refetch();
      conversationQuery.refetch();
    }, [refetch, conversationQuery])
  );

  // Keep the newest message in view unless the admin has scrolled up to read.
  useEffect(() => {
    const node = scrollRef.current;
    if (!node || !stickToBottom.current) return;
    node.scrollTop = node.scrollHeight;
  }, [messages]);

  const handleScroll = () => {
    const node = scrollRef.current;
    if (!node) return;
    const distanceFromBottom =
      node.scrollHeight - node.scrollTop - node.clientHeight;
    stickToBottom.current = distanceFromBottom < 80;
  };

  const loadOlder = async () => {
    const node = scrollRef.current;
    const previousHeight = node?.scrollHeight ?? 0;
    stickToBottom.current = false;
    await fetchNextPage();
    // Preserve the reading position after older messages are prepended.
    requestAnimationFrame(() => {
      if (!node) return;
      node.scrollTop = node.scrollHeight - previousHeight;
    });
  };

  /** Debounced, and skipped while the tab is hidden. */
  useEffect(() => {
    if (!conversationId || !lastMessageId || document.hidden) return;
    const timer = setTimeout(() => {
      markRead.mutate({ id: conversationId, lastMessageId });
    }, 800);
    return () => clearTimeout(timer);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [conversationId, lastMessageId]);

  const submit = (body: string, clientMessageId: string) => {
    setLocal((prev) =>
      mergeMessages(
        [],
        prev.map((message) =>
          message.client_message_id === clientMessageId
            ? { ...message, status: "pending" }
            : message
        )
      )
    );

    sendMessage.mutate(
      { id: conversationId, body: { body, client_message_id: clientMessageId } },
      {
        onSuccess: (message) => {
          setLocal((prev) =>
            mergeMessages([{ ...message, status: "sent" }], prev)
          );
          queryClient.invalidateQueries({
            queryKey: keys.conversations._def,
          });
        },
        onError: (error: {
          response?: { status?: number; data?: { message?: string } };
        }) => {
          const status = error.response?.status;
          setLocal((prev) =>
            prev.map((message) =>
              message.client_message_id === clientMessageId
                ? { ...message, status: "failed" }
                : message
            )
          );

          if (status === 429) {
            // Backend limit is 30 sends/min per actor.
            setSendBlockedUntil(Date.now() + 15000);
            snackbar({
              severity: "warning",
              message: "تم تجاوز حد الإرسال. حاول مرة أخرى بعد قليل.",
            });
            return;
          }
          if (status === 403) {
            conversationQuery.refetch();
            snackbar({
              severity: "error",
              message: "لا يمكن الإرسال في هذه المحادثة.",
            });
            return;
          }
          if (status === 404) {
            snackbar({ severity: "error", message: "المحادثة غير موجودة." });
            navigate(SUPPORT_PATH.SUPPORT);
            return;
          }
          snackbar({
            severity: "error",
            message: error.response?.data?.message ?? "تعذر إرسال الرسالة.",
          });
        },
      }
    );
  };

  const handleSend = () => {
    const body = draft.trim();
    if (!body || !composerEnabled) return;
    if (Date.now() < sendBlockedUntil) {
      snackbar({
        severity: "warning",
        message: "تم تجاوز حد الإرسال. حاول مرة أخرى بعد قليل.",
      });
      return;
    }

    const clientMessageId = newClientMessageId();
    setLocal((prev) =>
      mergeMessages(
        [
          {
            // Negative id keeps optimistic rows sorted last and out of the way
            // of real ids until the server row replaces them.
            id: -Date.now(),
            conversation_id: conversationId,
            service_request_id: null,
            client_message_id: clientMessageId,
            type: "text",
            body,
            deleted: false,
            sender: {
              type: "user",
              id: adminId ?? 0,
              display_role: "support",
            },
            reply_to_message_id: null,
            created_at: new Date().toISOString(),
            status: "pending",
          },
        ],
        prev
      )
    );

    setDraft("");
    stickToBottom.current = true;
    submit(body, clientMessageId);
  };

  /** Retrying reuses the same client_message_id, which the backend treats as idempotent. */
  const retry = (message: IChatMessageView) => {
    if (!message.body || !message.client_message_id) return;
    submit(message.body, message.client_message_id);
  };

  const handleKeyDown = (event: React.KeyboardEvent) => {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault();
      handleSend();
    }
  };

  if (conversationQuery.isError) {
    return (
      <Stack flex={1} alignItems="center" justifyContent="center" gap={2} p={3}>
        <Typography color="text.secondary">
          تعذر فتح المحادثة. قد تكون محذوفة أو لا تملك صلاحية الوصول إليها.
        </Typography>
        <Button onClick={() => navigate(SUPPORT_PATH.SUPPORT)}>
          العودة للقائمة
        </Button>
      </Stack>
    );
  }

  return (
    <Box
      sx={{
        height: "calc(100vh - 64px)",
        flex: 1,
        display: "flex",
        flexDirection: "column",
        minWidth: 0,
      }}
    >
      <AppBar position="static" sx={{ backgroundColor: "white", boxShadow: 1 }}>
        <Toolbar sx={{ gap: 1 }}>
          <IconButton
            edge="start"
            color="inherit"
            aria-label="رجوع"
            onClick={() => navigate(SUPPORT_PATH.SUPPORT)}
            sx={{
              color: "text.primary",
              [theme.breakpoints.up("md")]: { display: "none" },
            }}
          >
            <ArrowBackIcon />
          </IconButton>
          <Avatar>{counterpartName(conversation).charAt(0)}</Avatar>
          <Stack flexGrow={1} minWidth={0}>
            <Typography variant="h6" color="text.primary" noWrap>
              {counterpartName(conversation)}
            </Typography>
            <Stack direction="row" gap={0.5} alignItems="center">
              {conversation && (
                <>
                  <Chip
                    size="small"
                    variant="outlined"
                    label={
                      CONVERSATION_TYPE_LABEL[conversation.type] ??
                      conversation.type
                    }
                  />
                  {conversation.service_request && (
                    <Chip
                      size="small"
                      variant="outlined"
                      label={`طلب #${conversation.service_request.id}`}
                    />
                  )}
                </>
              )}
            </Stack>
          </Stack>
        </Toolbar>
      </AppBar>

      <Box
        ref={scrollRef}
        onScroll={handleScroll}
        sx={{ flex: 1, overflowY: "auto", background: "#f1f1f1", p: 2 }}
      >
        {hasNextPage && (
          <Stack alignItems="center" mb={2}>
            <Button size="small" onClick={loadOlder} disabled={isFetchingNextPage}>
              {isFetchingNextPage ? "جارٍ التحميل..." : "تحميل الرسائل الأقدم"}
            </Button>
          </Stack>
        )}

        {isLoading &&
          Array.from({ length: 6 }).map((_, index) => (
            <Stack key={index} alignItems={index % 2 ? "flex-start" : "flex-end"} mb={1}>
              <Skeleton variant="rounded" widthRange={{ min: 140, max: 260 }} height={48} />
            </Stack>
          ))}

        {!isLoading && !messages.length && (
          <Stack alignItems="center" mt={8}>
            <Typography color="text.secondary">لا توجد رسائل بعد</Typography>
          </Stack>
        )}

        {messages.map((message) => {
          const own = isOwnMessage(message, adminId);
          return (
            <Stack
              key={messageKey(message)}
              alignItems={own ? "flex-end" : "flex-start"}
              mb={1}
            >
              <Box
                sx={{
                  backgroundColor: own ? "#CDDFD5" : "white",
                  opacity: message.status === "pending" ? 0.6 : 1,
                  border: message.status === "failed" ? "1px solid" : "none",
                  borderColor: "error.main",
                  p: 1.25,
                  maxWidth: "min(70%, 460px)",
                  borderRadius: own ? "10px 10px 0 10px" : "10px 10px 10px 0",
                  wordBreak: "break-word",
                }}
              >
                {/* Rendered as text — never as HTML. */}
                <Typography whiteSpace="pre-wrap">
                  {message.deleted ? "(رسالة محذوفة)" : message.body}
                </Typography>
                <Stack
                  direction="row"
                  alignItems="center"
                  gap={0.5}
                  justifyContent="flex-end"
                >
                  <Typography variant="caption" color="textSecondary">
                    {formatTime(message.created_at)}
                  </Typography>
                  {message.status === "pending" && (
                    <Typography variant="caption" color="textSecondary">
                      • يُرسل
                    </Typography>
                  )}
                  {message.status === "failed" && (
                    <Tooltip title="إعادة المحاولة">
                      <IconButton size="small" onClick={() => retry(message)}>
                        <RefreshIcon fontSize="inherit" color="error" />
                      </IconButton>
                    </Tooltip>
                  )}
                </Stack>
              </Box>
            </Stack>
          );
        })}
      </Box>

      {composerEnabled ? (
        <Stack
          direction="row"
          alignItems="flex-end"
          gap={1}
          p={1}
          bgcolor="white"
        >
          <TextField
            fullWidth
            size="small"
            placeholder="اكتب رسالة"
            value={draft}
            onChange={(event) => setDraft(event.target.value)}
            onKeyDown={handleKeyDown}
            multiline
            maxRows={5}
            inputProps={{ maxLength: 5000 }}
          />
          <IconButton
            color="primary"
            onClick={handleSend}
            disabled={!draft.trim()}
            aria-label="إرسال"
          >
            {/* الأيقونة بتأشر لليمين افتراضياً — منعكسها حتى تناسب الواجهة العربية */}
            <SendIcon sx={{ transform: "scaleX(-1)" }} />
          </IconButton>
        </Stack>
      ) : (
        <Alert severity="info" icon={<LockOutlinedIcon />} sx={{ borderRadius: 0 }}>
          {isSupport(conversation)
            ? "لا يمكن الإرسال في هذه المحادثة."
            : "محادثات الطلبات للاطلاع فقط — لا يمكن للمشرف الإرسال فيها."}
        </Alert>
      )}
    </Box>
  );
};

export default Messages;
