import ErrorIcon from "@mui/icons-material/Error";
import { Stack, Typography } from "@mui/material";
const SomethingWentWrong = () => {
  return (
    <Stack alignItems={"center"} py={10} gap={1}>
      <ErrorIcon sx={{ height: "10rem", width: "10rem" }} color="error" />
      <Typography color="primary" variant="h5" textAlign={"center"}>
        حدث خطأ ما، يرجى إعادة المحاولة مرة أخرى
      </Typography>
    </Stack>
  );
};
export default SomethingWentWrong;
