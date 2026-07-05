import LogoutIcon from "@mui/icons-material/Logout";
import MenuIcon from "@mui/icons-material/Menu";
import { Box, Tooltip } from "@mui/material";
import MuiAppBar, { AppBarProps as MuiAppBarProps } from "@mui/material/AppBar";
import IconButton from "@mui/material/IconButton";
import Toolbar from "@mui/material/Toolbar";
import Typography from "@mui/material/Typography";
import { styled } from "@mui/material/styles";
import { FC } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { drawerWidth } from "./layout";
import { createSideBarItems } from "@constants/sideBarItems";
import { AUTH_PATH } from "../../../src/routes/path";
import { AddSubscription } from "@pages/users/addSubscription";
interface AppBarProps extends MuiAppBarProps {
  open?: boolean;
}

export const AppBarStyled = styled(MuiAppBar, {
  shouldForwardProp: (prop) => prop !== "open",
})<AppBarProps>(({ theme, open }) => ({
  zIndex: theme.zIndex.drawer + 1,
  transition: theme.transitions.create(["width", "margin"], {
    easing: theme.transitions.easing.sharp,
    duration: theme.transitions.duration.leavingScreen,
  }),
  ...(open && {
    marginLeft: drawerWidth,
    transition: theme.transitions.create(["width", "margin"], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.enteringScreen,
    }),
  }),
}));
type Props = {
  open: boolean;
  onDrawerOpen: () => void;
  onDrawerClose: () => void;
};
const AppBar: FC<Props> = ({ open, onDrawerOpen, onDrawerClose }) => {
  const navigate = useNavigate();
  const path = useLocation().pathname.split("/")[1];
  const pageTitle = createSideBarItems.map((side) =>
    side.find(({ href }) => path == href),
  )[0];

  const handleLogout = () => {
    navigate(AUTH_PATH.LOGIN);
    localStorage.removeItem("token");
  };
  return (
    <AppBarStyled position="fixed" open={open} key={path}>
      <Toolbar>
        <IconButton
          color="inherit"
          onClick={open ? onDrawerClose : onDrawerOpen}
          edge="start"
        >
          <MenuIcon sx={{ color: "white" }} />
        </IconButton>
        <Typography variant="h6" noWrap component="div" pl={0.5}>
          {`${pageTitle?.text}`}
        </Typography>
        <Box
          sx={{
            flex: "1",
            display: "flex",
            justifyContent: "end",
            alignItems: "center",
            mt: "4px",
          }}
        >
          <Tooltip title={"تسجيل الخروج"}>
            <IconButton onClick={handleLogout}>
              <LogoutIcon sx={{ color: "white", ml: "auto" }} />
            </IconButton>
          </Tooltip>
        </Box>
      </Toolbar>
    </AppBarStyled>
  );
};
export default AppBar;
