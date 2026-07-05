import { queries } from "@apis/support/queries";
import Skeleton from "@components/feedbacks/skeleton";
import SearchFilter from "@components/inputs/searchFilter";
import FilterRow from "@components/layout/filterRow";
import useQuerySearchParam from "@hooks/useQuerySearchParam";
import { SUPPORT_PATH } from "../../../src/routes/path";

import {
  Avatar,
  Divider,
  Grid,
  List,
  ListItem,
  ListItemAvatar,
  ListItemText,
  Stack,
  Typography,
  useMediaQuery,
} from "@mui/material";
import QuestionAnswerIcon from "@mui/icons-material/QuestionAnswer";
import { useTheme } from "@mui/material/styles";
import { Fragment, useMemo } from "react";
import { useLocation, useNavigate, useParams } from "react-router-dom";

/** Mock-only: set false to use live API list again. */
export const USE_MOCK_SUPPORT_CHATS = true;

export type MockChatListUser = {
  id: string;
  firstName: string;
  lastName: string;
  dialCode: string;
  phoneNumber: string;
  email: string;
  scanStartDate: string;
  scanEndDate: string;
};

export const MOCK_CHAT_USERS: MockChatListUser[] = [
  {
    id: "mock-support-1",
    firstName: "سارة",
    lastName: "محمود",
    dialCode: "+963",
    phoneNumber: "933111222",
    email: "sara@example.com",
    scanStartDate: "",
    scanEndDate: "",
  },
  {
    id: "mock-support-2",
    firstName: "كريم",
    lastName: "الناصر",
    dialCode: "+963",
    phoneNumber: "944222333",
    email: "karim@example.com",
    scanStartDate: "",
    scanEndDate: "",
  },
  {
    id: "mock-support-3",
    firstName: "ليان",
    lastName: "عبدالله",
    dialCode: "+963",
    phoneNumber: "955333444",
    email: "layan@example.com",
    scanStartDate: "",
    scanEndDate: "",
  },
];

const Chats = () => {
  const navigate = useNavigate();
  const { pathname } = useLocation();
  const { id } = useParams();
  const theme = useTheme();
  const isMdDown = useMediaQuery(theme.breakpoints.down("md"));
  const search = useQuerySearchParam();
  const query = queries.GetAllChat({
    Query: search,
    PageSize: 0,
  });
  const { data, isLoading, isSuccess } = query;

  const mockFiltered = useMemo(() => {
    const q = (search ?? "").trim().toLowerCase();
    if (!q) return MOCK_CHAT_USERS;
    return MOCK_CHAT_USERS.filter((u) =>
      `${u.firstName} ${u.lastName} ${u.phoneNumber}`.toLowerCase().includes(q)
    );
  }, [search]);

  const listUsers = USE_MOCK_SUPPORT_CHATS
    ? mockFiltered
    : data?.pages[0]?.data ?? [];

  const effectiveLoading = USE_MOCK_SUPPORT_CHATS ? false : isLoading;
  const effectiveSuccess = USE_MOCK_SUPPORT_CHATS ? true : isSuccess;
  const noData = !listUsers.length && effectiveSuccess;

  return (
    <List
      sx={{
        height: "calc(100vh - 64px)",
        overflow: "scroll",
        minWidth: "300px",
        backgroundColor: "white",
        marginY: 0,
        padding: 0,
        margin: "0 !important",
        [theme.breakpoints.down("md")]: {
          display: pathname.includes(SUPPORT_PATH.MESSAGES) && "none",
          width: pathname === SUPPORT_PATH.SUPPORT && "100%",
        },
      }}
    >
      <FilterRow sx={{ marginTop: "0px", justifyContent: "center" }}>
        <Grid item lg={12} sx={{ padding: "10px", marginY: "10px" }}>
          <SearchFilter label={"البحث"} />
        </Grid>
      </FilterRow>
      {noData && (
        <Stack justifyContent="center" alignItems="center" mt={12.5}>
          <QuestionAnswerIcon sx={{ color: "primary.main", fontSize: 200 }} />
          <Typography color="#444" fontSize="clamp(17px,4vw,23px)">
            لا يوجد محادثات
          </Typography>
        </Stack>
      )}
      <Stack
        sx={{
          gap: "10px",
          margin: "10px",
          marginLeft: isMdDown ? "20px" : "10px",
        }}
      >
        {effectiveLoading &&
          Array.from({ length: 10 }).map((_, index) => (
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
      {!effectiveLoading &&
        listUsers.map((user) => (
          <Fragment key={user.id}>
            <ListItem
              alignItems="center"
              sx={{
                ":hover": {
                  background: "#f1f1f1",
                  cursor: "pointer",
                },
                bgcolor: id == user.id ? "#f1f1f1" : "inherit",
              }}
              onClick={() => {
                navigate("messages/" + user.id, {
                  state: user.firstName + " " + user.lastName,
                });
              }}
            >
              <ListItemAvatar>
                <Avatar alt="Remy Sharp" src="" />
              </ListItemAvatar>
              <ListItemText primary={user?.firstName + " " + user?.lastName} />
            </ListItem>
            <Divider />
          </Fragment>
        ))}
    </List>
  );
};

export default Chats;
