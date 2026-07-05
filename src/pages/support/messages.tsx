import {
  AppBar,
  Avatar,
  Box,
  Button,
  IconButton,
  TextField,
  Toolbar,
  Typography,
} from "@mui/material";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import SendIcon from "@mui/icons-material/Send";
import { useEffect, useRef, useState } from "react";
import { useSideBar } from "@context/sideBarContext";
import { useTheme } from "@mui/material/styles";
import { useLocation, useNavigate, useParams } from "react-router-dom";
import { VariableSizeList as VirtualizedList } from "react-window";
import { queries } from "@apis/support/queries";
import { BACKEND_REALTIME_URL } from "@lib/axios";
import { SUPPORT_PATH } from "../../../src/routes/path";

/** Mock-only: set false to use live API + WebSocket again. */
const USE_MOCK_SUPPORT_MESSAGES = true;

type MockApiMessage = {
  message: string;
  fromAdmin: boolean;
  date: string;
};

const MOCK_CONVERSATIONS: Record<string, MockApiMessage[]> = {
  "mock-support-1": [
    {
      message: "مرحباً، أحتاج مساعدة في تفعيل الحساب.",
      fromAdmin: false,
      date: new Date(Date.now() - 1000 * 60 * 120).toISOString(),
    },
    {
      message: "وعليكم السلام، سأساعدك الآن. ما البريد المستخدم في التسجيل؟",
      fromAdmin: true,
      date: new Date(Date.now() - 1000 * 60 * 118).toISOString(),
    },
    {
      message: "sara@example.com",
      fromAdmin: false,
      date: new Date(Date.now() - 1000 * 60 * 115).toISOString(),
    },
    {
      message: "تم التحقق. جرّب تسجيل الدخول مرة أخرى بعد دقيقة.",
      fromAdmin: true,
      date: new Date(Date.now() - 1000 * 60 * 110).toISOString(),
    },
  ],
  "mock-support-2": [
    {
      message: "السلام عليكم، التطبيق يتوقف عند فتح الكتب.",
      fromAdmin: false,
      date: new Date(Date.now() - 1000 * 60 * 200).toISOString(),
    },
    {
      message: "عليكم السلام، ما إصدار النظام على جهازك؟",
      fromAdmin: true,
      date: new Date(Date.now() - 1000 * 60 * 198).toISOString(),
    },
    {
      message: "Android 13",
      fromAdmin: false,
      date: new Date(Date.now() - 1000 * 60 * 195).toISOString(),
    },
  ],
  "mock-support-3": [
    {
      message: "كيف أغير كلمة المرور؟",
      fromAdmin: false,
      date: new Date(Date.now() - 1000 * 60 * 45).toISOString(),
    },
    {
      message: "من الإعدادات > الأمان > تغيير كلمة المرور.",
      fromAdmin: true,
      date: new Date(Date.now() - 1000 * 60 * 42).toISOString(),
    },
  ],
};

const mapMockToUi = (rows: MockApiMessage[]) =>
  rows.map((message) => ({
    ...message,
    message: message.message ? message.message : "",
    timestamp: message.date
      ? new Date(message.date).toLocaleTimeString("en-US", {
          hour: "numeric",
          minute: "numeric",
        })
      : "",
  }));

type VirtualizedListType = {
  index: number;
  style: React.CSSProperties;
};

type MessageType = {
  message: string;
  timestamp: string;
  fromAdmin: boolean;
};

let socket: WebSocket | undefined;

const Messages = () => {
  const { id = "" } = useParams();
  const { state, pathname } = useLocation();
  const { isOpen } = useSideBar();
  const theme = useTheme();
  const navigate = useNavigate();
  const [message, setMessage] = useState("");
  const [chatMessages, setChatMessages] = useState<MessageType[]>([]);
  const [page, setPage] = useState(0);
  console.log(page);
  const listRef = useRef<any | null>(null);
  const { data, fetchNextPage } = queries.GetChatsUser({
    TeacherId: id,
    PageSize: 25,
  });
  const name = localStorage.getItem("userName");

  useEffect(() => {
    if (USE_MOCK_SUPPORT_MESSAGES) return;
    if (data?.pages?.[page]?.data) {
      const reversedData = data.pages[page].data.length
        ? data.pages[page].data.reverse().map((message) => ({
            ...message,
            message: message.message ? message.message : "",
            timestamp: message.date
              ? new Date(message.date).toLocaleTimeString("en-US", {
                  hour: "numeric",
                  minute: "numeric",
                })
              : "",
          }))
        : [];
      setChatMessages((prev) => [...reversedData, ...prev]);
      setPage((prev) => prev + 1);
    }
  }, [data]);

  useEffect(() => {
    if (USE_MOCK_SUPPORT_MESSAGES) {
      const rows = MOCK_CONVERSATIONS[id] ?? [];
      setChatMessages(mapMockToUi(rows));
      setPage(0);
      return;
    }
    setPage(0);
    setChatMessages([]);
  }, [id]);

  useEffect(() => {
    if (state) {
      localStorage.setItem("userName", state);
    }
    if (listRef.current) {
      window.scrollTo({
        top: listRef.current.scrollHeight,
        behavior: "smooth",
      });
      listRef.current.scrollTop = listRef.current.scrollHeight;
    }
  }, [state]);

  const getItemSize = (index: number) => {
    const { message } = chatMessages[index];
    const baseHeight = 60;
    const additionalHeightPerLine = 20;
    const lineCount = Math.ceil(message?.length / 40);
    return baseHeight + lineCount * additionalHeightPerLine;
  };

  const renderRow = ({ index, style }: VirtualizedListType) => {
    const msg = chatMessages[index];
    return (
      <div
        style={{
          ...style,
          display: "flex",
          justifyContent: msg.fromAdmin ? "flex-start" : "flex-end",
        }}
      >
        <div
          style={{
            backgroundColor: msg.fromAdmin ? "#CDDFD5" : "white",
            padding: "10px",
            margin: "10px",
            maxWidth: "400px",
            borderRadius: msg.fromAdmin
              ? "10px 10px 10px 0"
              : "10px 10px 0px 10px",
            wordBreak: "break-word",
          }}
        >
          <Typography>{msg.message}</Typography>
          <Typography
            variant="caption"
            color="textSecondary"
            sx={{ display: "block", textAlign: "left" }}
          >
            {msg.timestamp}
          </Typography>
        </div>
      </div>
    );
  };

  const handleSend = () => {
    if (message.trim()) {
      const messageWithTime = {
        message: message,
        timestamp: new Date().toLocaleTimeString("en-US", {
          hour: "numeric",
          minute: "numeric",
        }),
        fromAdmin: true,
      };
      setChatMessages([...chatMessages, messageWithTime]);
      if (socket && socket.readyState === WebSocket.OPEN) {
        socket.send(
          JSON.stringify({
            Message: message,
            TeacherId: id,
          })
        );
      }
      setMessage("");
      setTimeout(() => {
        if (listRef.current) {
          listRef.current.scrollToItem(chatMessages.length + 1);
        }
      }, 0);
    }
  };

  const handleKeyDown = (event: React.KeyboardEvent<HTMLDivElement>) => {
    if (event.key === "Enter") {
      if (message.trim() !== "") {
        event.preventDefault();
        const messageWithTime = {
          message: message,
          timestamp: new Date().toLocaleTimeString("en-US", {
            hour: "numeric",
            minute: "numeric",
          }),
          fromAdmin: true,
        };
        setChatMessages([...chatMessages, messageWithTime]);
        handleSend();
      } else {
        event.preventDefault();
      }
    }
  };

  const handleScroll = () => {
    if (listRef.current) {
      const { scrollTop } = listRef.current._outerRef;
      if (scrollTop === 0) {
        console.log("top");
        if (!USE_MOCK_SUPPORT_MESSAGES) {
          fetchNextPage();
        }
      }
    }
  };

  useEffect(() => {
    if (USE_MOCK_SUPPORT_MESSAGES || !id) return;
    socket = new WebSocket(
      `${BACKEND_REALTIME_URL}/Chat?token=${localStorage.getItem(
        "token"
      )}&TeacherId=${id}`
    );
    return () => {
      if (socket) {
        socket.onclose = (event) => {
          console.log("WebSocket closed: ", event);
        };
        socket.close();
      }
      socket = undefined;
    };
  }, [id]);

  useEffect(() => {
    if (USE_MOCK_SUPPORT_MESSAGES) return;
    if (!socket) return;
    socket.onmessage = (event) => {
      const message = JSON.parse(event.data);
      const messageWithTime = {
        message: message.Message,
        timestamp: new Date().toLocaleTimeString("en-US", {
          hour: "numeric",
          minute: "numeric",
        }),
        fromAdmin: false,
      };
      setChatMessages((prev) => [...prev, messageWithTime]);
    };
  }, []);

  useEffect(() => {
    if (listRef.current) {
      listRef.current.resetAfterIndex(0, true);
      if (page <= 1) {
        listRef.current.scrollToItem(chatMessages.length);
      }
    }
  }, [chatMessages, page]);

  useEffect(() => {
    if (listRef.current) {
      listRef.current._outerRef.addEventListener("scroll", handleScroll);
    }

    return () => {
      if (listRef.current) {
        listRef.current._outerRef.removeEventListener("scroll", handleScroll);
      }
    };
  }, [chatMessages]);

  const closeSocketAndLeave = () => {
    if (socket) {
      socket.onclose = (event) => {
        console.log("WebSocket closed: ", event);
      };
      socket.close();
    }
    socket = undefined;
    navigate(SUPPORT_PATH.SUPPORT);
  };

  return (
    <Box
      sx={{
        height: "calc(100vh - 64px)",
        flex: 1,
        width: isOpen ? "calc(100vw - 543px)" : "calc(100vw - 360px)",
        [theme.breakpoints.down("md")]: {
          width: pathname.includes(SUPPORT_PATH.MESSAGES) && "100%",
        },
      }}
    >
      <AppBar
        position="static"
        sx={{
          backgroundColor: "white",
          ".MuiAppBar-root": {
            boxShadow: "none",
          },
        }}
      >
        <Toolbar sx={{ flex: 1 }}>
          <Avatar alt={"state"} src="" sx={{ marginRight: 2 }} />
          <Typography variant="h6" sx={{ flexGrow: 1, color: "text.primary" }}>
            {name}
          </Typography>
          <IconButton
            edge="start"
            color="inherit"
            aria-label="back"
            onClick={() => {
              if (USE_MOCK_SUPPORT_MESSAGES) {
                navigate(SUPPORT_PATH.SUPPORT);
                return;
              }
              closeSocketAndLeave();
            }}
          >
            <ArrowBackIcon />
          </IconButton>
        </Toolbar>
      </AppBar>
      <Box
        sx={{
          width: "100%",
          background: "#f1f1f1",
          height: "calc(100vh - 180px)",
          overflow: "hidden",
        }}
      >
        <VirtualizedList
          ref={listRef}
          height={window.innerHeight - 196}
          itemCount={chatMessages.length + 1}
          itemSize={(index: number) =>
            index != 0 ? getItemSize(index - 1) : 10
          }
          width={"100%"}
          style={{ overflow: "hidden auto" }}
        >
          {({ index, style }: VirtualizedListType) => {
            if (index === 0) {
              return;
            }
            return renderRow({ index: index - 1, style });
          }}
        </VirtualizedList>
      </Box>
      <Box
        sx={{
          position: "sticky",
          bottom: 0,
          width: "100%",
          margin: "0",
          background: "white",
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        <Button onClick={handleSend}>
          <SendIcon sx={{ fontSize: "2.5rem" }} />
        </Button>
        <TextField
          sx={{ width: "95%" }}
          placeholder="اكتب رسالة"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          onKeyDown={handleKeyDown}
          multiline
        />
      </Box>
    </Box>
  );
};

export default Messages;
