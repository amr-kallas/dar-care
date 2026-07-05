import { Stack, Typography } from "@mui/material";
import AnnouncementIcon from "@mui/icons-material/Announcement";
import Chats, { MOCK_CHAT_USERS, USE_MOCK_SUPPORT_CHATS } from "./chats";
import { useParams } from "react-router-dom";
import { useLocation } from "react-router-dom";
import { useTheme } from "@mui/material/styles";
import Messages from "./messages";
import { SUPPORT_PATH } from "../../../src/routes/path";
const Support = () => {
  const { id } = useParams();
  const { pathname } = useLocation();
  const theme = useTheme();

  return (
    <Stack
      justifyContent="space-between"
      alignItems="center"
      direction={"row"}
      spacing={2}
    >
      {pathname === SUPPORT_PATH.SUPPORT ? (
        <Stack
          justifyContent="center"
          alignItems="center"
          sx={{
            height: "calc(100vh - 64px)",
            width: "calc(100vw - 400px)",
            [theme.breakpoints.down("md")]: {
              display: pathname === SUPPORT_PATH.SUPPORT && "none",
            },
          }}
          spacing={2}
        >
          <AnnouncementIcon sx={{ color: "primary.main", fontSize: 200 }} />
          <Typography variant="h3" color="#444" >
            اختر دردشة
          </Typography>
          {USE_MOCK_SUPPORT_CHATS && (
            <Typography
              variant="body1"
              color="text.secondary"
              textAlign="center"
              maxWidth={520}
              px={2}
            >
              بيانات تجريبية: يمكنك فتح محادثة من القائمة اليمنى مع{" "}
              {MOCK_CHAT_USERS.map((u) => `${u.firstName} ${u.lastName}`).join("، ")}
              .
            </Typography>
          )}
        </Stack>
      ) : (
        <Messages key={id} />
      )}
      <Chats />
    </Stack>
  );
};

export default Support;
