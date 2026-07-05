
import queries from "../../apis/auth/queries";
import Submit from "@components/buttons/Submit";
import { PasswordInput } from "@components/inputs/PasswordInput";
import TextField from "@components/inputs/textField";
import { Box, Paper, Typography } from "@mui/material";
import { Stack } from "@mui/system";
import { ILoginForm, LoginDefaultValues, loginValidation } from "./logInValidation";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import { yupResolver } from "@hookform/resolvers/yup";
import { useSnackbar } from "@context/snackbarContext";
export const LoginForm = () => {
  const snackbar = useSnackbar();
  const { control, handleSubmit } = useForm<ILoginForm>({
    defaultValues: LoginDefaultValues,
    resolver: yupResolver(loginValidation),
  });
  const navigate = useNavigate();
  const { mutate, isPending } = queries.Login();
  const submitHandler = (data:any) => {
    mutate(data, {
      onSuccess: (body) => {
        localStorage.setItem("token", body.token);
        snackbar({
          message: "تم تسجيل الدخول بنجاح",
          severity: "success",
        });
        navigate("/");
      },
      onError: (error) => {
        snackbar({
          message: error.response.data.errorMessage,
          severity: "error",
        });
      },
    });
  };

  return (
    <Paper
      onSubmit={handleSubmit(submitHandler)}
      // elevation={2}
      component={Stack}
      gap={5}
      sx={{
        pt: "40px",
        px: { xs: 1, sm: "50px" },
        pb: "32px",
      }}
    >
      <Typography color="primary" variant="h5" textAlign={"center"}>
        تسجيل الدخول
      </Typography>
      <Stack gap={2} component={"form"} width="80%" mx="auto">
        {/* <EmailInput control={control} name="email" /> */}
        <TextField control={control} name="userName" label="اسم المتسخدم" />
        <PasswordInput control={control} name="password" />
        <Box m="auto" width="fit-content">
          <Submit
            sx={{
              px: 5,
              ":hover": {
                background: "#4D8547",
              },
            }}
            isSubmitting={isPending}
          >
            تسجيل الدخول
          </Submit>
        </Box>
      </Stack>  

    </Paper>
  );
};
export default LoginForm;
