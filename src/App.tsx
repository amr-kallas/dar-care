import { Box, LinearProgress, ThemeProvider } from "@mui/material";
import { Suspense } from "react";
import { RouterProvider } from "react-router-dom";
import theme from "./context/themeContext";
import routes from "./routes/routes";

import createCache from "@emotion/cache";
import { CacheProvider } from "@emotion/react";
import { prefixer } from "stylis";
import rtlPlugin from "stylis-plugin-rtl";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { SideBarProvider } from "@context/sideBarContext";
import SnackbarProvider from "./wrapper/snackbarProvider";
const cacheRtl = createCache({
  key: "muirtl",
  stylisPlugins: [prefixer, rtlPlugin],
});

function App() {
  const queryClient = new QueryClient();
  return (
    <QueryClientProvider client={queryClient}>
      <SideBarProvider>
        <ThemeProvider theme={theme("ar")}>
          <SnackbarProvider>
            <CacheProvider value={cacheRtl}>
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
                <RouterProvider router={routes} />
              </Suspense>
            </CacheProvider>
          </SnackbarProvider>
        </ThemeProvider>
      </SideBarProvider>
    </QueryClientProvider>
  );
}

export default App;
