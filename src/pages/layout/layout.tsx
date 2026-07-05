import { Box, LinearProgress, Toolbar, useMediaQuery, useTheme } from "@mui/material";
import { FC, Suspense, useState } from "react";
import { Outlet } from "react-router-dom";
import AppBar from "./appBar";
import Main from "./main";
import Sidebar from "./SideBar";
export const drawerWidth = 240;
import { useSideBar } from "@context/sideBarContext";
type Props = {};
const Layout: FC<Props> = ({}) => {
  const theme = useTheme();
  const isLargeScreen = useMediaQuery(theme.breakpoints.up("md"));
  const { setIsOpen } = useSideBar();
  const [open, setOpen] = useState<boolean>(isLargeScreen);
  const handleDrawerOpen = () => {
    setOpen(true);
    setIsOpen(true);
  };
  const handleDrawerClose = () => {
    setOpen(false);
    setIsOpen(false);
  };
  return (
    <Box>
      <AppBar
        open={open}
        onDrawerOpen={handleDrawerOpen}
        onDrawerClose={handleDrawerClose}
      />
      <Sidebar open={open} setOpen={setOpen} />
      <Toolbar />
      <Main open={open} sx={{ px: { xs: 0, sm: 0 }, py: 0  }}>
        <Suspense
          fallback={
            <Box
              sx={{
                width: "100%",
                position: "fixed",
                top: 0,
                left: 0,
                zIndex: 99999999,
              }}
            >
              <LinearProgress
                variant="indeterminate"
                sx={{ padding: 0.4 }}
                color="primary"
              />
            </Box>
          }
        >
          <Outlet />
        </Suspense>
      </Main>
    </Box>
  );
};
export default Layout;
