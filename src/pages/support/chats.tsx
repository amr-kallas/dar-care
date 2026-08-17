import { queries } from "@apis/chat/queries";
import type { IConversation } from "@apis/chat/type";
import Skeleton from "@components/feedbacks/skeleton";
import SearchFilter from "@components/inputs/searchFilter";
import useQuerySearchParam from "@hooks/useQuerySearchParam";
import QuestionAnswerIcon from "@mui/icons-material/QuestionAnswer";
import {
  Avatar,
  Badge,
  Box,
  Button,
  Chip,
  Divider,
  List,
  ListItemButton,
  ListItemAvatar,
  ListItemText,
  MenuItem,
  Stack,
  TextField,
  Typography,
  useMediaQuery,
} from "@mui/material";
import { useTheme } from "@mui/material/styles";
import { Fragment, useMemo, useState } from "react";
import { useLocation, useNavigate, useParams } from "react-router-dom";
import { SUPPORT_PATH } from "../../routes/path";
import {
  CONVERSATION_STATUS_LABEL,
  CONVERSATION_TYPE_LABEL,
  counterpartName,
  formatDay,
} from "./chatHelpers";

const TYPE_OPTIONS = [
  { value: "", label: "كل الأنواع" },
  { value: "support_customer", label: CONVERSATION_TYPE_LABEL.support_customer },
  { value: "support_provider", label: CONVERSATION_TYPE_LABEL.support_provider },
  { value: "request", label: CONVERSATION_TYPE_LABEL.request },
];

const STATUS_OPTIONS = [
  { value: "", label: "كل الحالات" },
  { value: "open", label: CONVERSATION_STATUS_LABEL.open },
  { value: "closed", label: CONVERSATION_STATUS_LABEL.closed },
  { value: "read_only", label: CONVERSATION_STATUS_LABEL.read_only },
];

const statusColor = (status: string) =>
  status === "open" ? "success" : status === "closed" ? "default" : "warning";

const Chats = () => {
  const navigate = useNavigate();
  const { pathname } = useLocation();
  const { id } = useParams();
  const theme = useTheme();
  const isMdDown = useMediaQuery(theme.breakpoints.down("md"));
  const search = useQuerySearchParam();
  const [type, setType] = useState("");
  const [status, setStatus] = useState("");

  const {
    data,
    isLoading,
    isSuccess,
    fetchNextPage,
    hasNextPage,
    isFetchingNextPage,
  } = queries.GetConversations({ search, type, status });

  const conversations = useMemo(
    () => (data?.pages ?? []).flatMap((page) => page.data),
    [data]
  );

  const noData = !conversations.length && isSuccess;

  return (
    <List
      sx={{
        height: "calc(100vh - 64px)",
        overflowY: "auto",
        width: "340px",
        flexShrink: 0,
        backgroundColor: "white",
        padding: 0,
        margin: "0 !important",
        [theme.breakpoints.down("md")]: {
          display: pathname.includes("messages/") ? "none" : "block",
          width: "100%",
        },
      }}
    >
      <Stack gap={1.5} p={1.5} position="sticky" top={0} bgcolor="white" zIndex={1}>
        <SearchFilter label="بحث في الرسائل" />
        <Stack direction="row" gap={1}>
          <TextField
            select
            size="small"
            fullWidth
            label="النوع"
            value={type}
            onChange={(event) => setType(event.target.value)}
          >
            {TYPE_OPTIONS.map((option) => (
              <MenuItem key={option.value} value={option.value}>
                {option.label}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            select
            size="small"
            fullWidth
            label="الحالة"
            value={status}
            onChange={(event) => setStatus(event.target.value)}
          >
            {STATUS_OPTIONS.map((option) => (
              <MenuItem key={option.value} value={option.value}>
                {option.label}
              </MenuItem>
            ))}
          </TextField>
        </Stack>
      </Stack>
      <Divider />

      {isLoading && (
        <Stack sx={{ gap: "10px", m: isMdDown ? "10px 20px" : "10px" }}>
          {Array.from({ length: 8 }).map((_, index) => (
            <Stack direction="row" sx={{ gap: "10px" }} key={index}>
              <Skeleton variant="circular" width={40} height={40} />
              <Skeleton
                variant="text"
                widthRange={{ min: 100, max: 150 }}
                height={50}
              />
            </Stack>
          ))}
        </Stack>
      )}

      {noData && (
        <Stack justifyContent="center" alignItems="center" mt={10} px={2}>
          <QuestionAnswerIcon sx={{ color: "primary.main", fontSize: 140 }} />
          <Typography color="#444" fontSize="clamp(15px,4vw,20px)">
            لا يوجد محادثات
          </Typography>
        </Stack>
      )}

      {!isLoading &&
        conversations.map((conversation: IConversation) => (
          <Fragment key={conversation.id}>
            <ListItemButton
              alignItems="flex-start"
              selected={id === String(conversation.id)}
              onClick={() => navigate(`messages/${conversation.id}`)}
              sx={{ ":hover": { background: "#f1f1f1" } }}
            >
              <ListItemAvatar>
                <Badge
                  color="primary"
                  badgeContent={conversation.unread_count}
                  invisible={!conversation.unread_count}
                >
                  <Avatar>{counterpartName(conversation).charAt(0)}</Avatar>
                </Badge>
              </ListItemAvatar>
              <ListItemText
                primary={
                  <Stack
                    direction="row"
                    alignItems="center"
                    justifyContent="space-between"
                    gap={1}
                  >
                    <Typography noWrap fontWeight={600} fontSize={15}>
                      {counterpartName(conversation)}
                    </Typography>
                    <Typography
                      variant="caption"
                      color="text.secondary"
                      flexShrink={0}
                    >
                      {formatDay(conversation.last_message_at)}
                    </Typography>
                  </Stack>
                }
                secondary={
                  <Box component="span" display="block">
                    <Typography
                      component="span"
                      variant="body2"
                      color="text.secondary"
                      noWrap
                      display="block"
                    >
                      {conversation.last_message?.body ?? "لا توجد رسائل بعد"}
                    </Typography>
                    <Stack direction="row" gap={0.5} mt={0.5} component="span">
                      <Chip
                        size="small"
                        variant="outlined"
                        label={
                          CONVERSATION_TYPE_LABEL[conversation.type] ??
                          conversation.type
                        }
                      />
                      <Chip
                        size="small"
                        color={statusColor(conversation.status)}
                        label={
                          CONVERSATION_STATUS_LABEL[conversation.status] ??
                          conversation.status
                        }
                      />
                    </Stack>
                  </Box>
                }
              />
            </ListItemButton>
            <Divider component="li" />
          </Fragment>
        ))}

      {hasNextPage && (
        <Stack p={1.5}>
          <Button
            onClick={() => fetchNextPage()}
            disabled={isFetchingNextPage}
            size="small"
          >
            {isFetchingNextPage ? "جارٍ التحميل..." : "تحميل المزيد"}
          </Button>
        </Stack>
      )}
    </List>
  );
};

export default Chats;
