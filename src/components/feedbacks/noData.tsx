import ErrorIcon from "@mui/icons-material/Error";
import { Stack, Typography } from "@mui/material";
const NoData = () => {
  return (
    <Stack alignItems={"center"} py={10} gap={1}>
      <ErrorIcon sx={{ height: "10rem", width: "10rem" }} color="error" />
      <Typography color="primary" variant="h5" textAlign={"center"}>
        لا يوجد بيانات
      </Typography>
    </Stack>
  );
};
export default NoData;
