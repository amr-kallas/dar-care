import ErrorIcon from "@mui/icons-material/Error";
import { Stack, Typography } from "@mui/material";
const NotFound = () => {
  return (
    <Stack alignItems={"center"} py={10} gap={1}>
      <ErrorIcon sx={{ height: "10rem", width: "10rem" }} color="error" />
      <Typography color="primary" variant="h5" textAlign={"center"}>
        error.notFound
      </Typography>
    </Stack>
  );
};
export default NotFound;
