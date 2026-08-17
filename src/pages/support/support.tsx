import { keys } from "@apis/chat/queries";
import { useAdminInboxChannel } from "@hooks/useChatChannels";
import AnnouncementIcon from "@mui/icons-material/Announcement";
import { Stack, Typography } from "@mui/material";
import { useTheme } from "@mui/material/styles";
import { useQueryClient } from "@tanstack/react-query";
import { useCallback } from "react";
import { useLocation, useParams } from "react-router-dom";
import { SUPPORT_PATH } from "../../routes/path";
import Chats from "./chats";
import Messages from "./messages";

const Support = () => {
  const { id } = useParams();
  const { pathname } = useLocation();
  const theme = useTheme();
  const queryClient = useQueryClient();

  /**
   * Admins are not conversation participants, so there is no participant-based
   * unread signal and no ConversationCreated event. The inbox channel is what
   * tells us a new support thread or reply exists — refresh the list on it.
   */
  useAdminInboxChannel(
    useCallback(() => {
      queryClient.invalidateQueries({ queryKey: keys.conversations._def });
    }, [queryClient])
  );

  const hasOpenThread = pathname !== SUPPORT_PATH.SUPPORT;

  return (
    <Stack direction="row" height="calc(100vh - 64px)">
      <Chats />
      {hasOpenThread ? (
        <Messages key={id} />
      ) : (
        <Stack
          flex={1}
          justifyContent="center"
          alignItems="center"
          spacing={2}
          sx={{
            [theme.breakpoints.down("md")]: { display: "none" },
          }}
        >
          <AnnouncementIcon sx={{ color: "primary.main", fontSize: 180 }} />
          <Typography variant="h4" color="#444">
            اختر محادثة
          </Typography>
        </Stack>
      )}
    </Stack>
  );
};

export default Support;
