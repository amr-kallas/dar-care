import queries from "../../apis/auth/queries";
import Submit from "@components/buttons/Submit";
import { PasswordInput } from "@components/inputs/PasswordInput";
import TextField from "@components/inputs/textField";
import { Box, Paper, Typography } from "@mui/material";
import { Stack } from "@mui/system";
import {
  ILoginForm,
  LoginDefaultValues,
  loginValidation,
} from "./logInValidation";
import { useForm } from "react-hook-form";
import { useNavigate } from "react-router-dom";
import { yupResolver } from "@hookform/resolvers/yup";
import { useSnackbar } from "@context/snackbarContext";
import { setSession } from "@lib/session";

export const LoginForm = () => {
  const snackbar = useSnackbar();
  const { control, handleSubmit } = useForm<ILoginForm>({
    defaultValues: LoginDefaultValues,
    resolver: yupResolver(loginValidation),
  });
  const navigate = useNavigate();
  const { mutate, isPending } = queries.Login();

  const submitHandler = (formData: ILoginForm) => {
    mutate(formData, {
      onSuccess: (body) => {
        // The admin id is persisted so the app can subscribe to the private
        // inbox channel `user.user.{adminId}`.
        setSession(body.token, body.user);
        snackbar({
          message: "تم تسجيل الدخول بنجاح",
          severity: "success",
        });
        navigate("/");
      },
      onError: (error: {
        message?: string;
        response?: { data?: { message?: string; errorMessage?: string } };
      }) => {
        snackbar({
          message:
            error.response?.data?.message ??
            error.response?.data?.errorMessage ??
            error.message ??
            "فشل تسجيل الدخول",
          severity: "error",
        });
      },
    });
  };

  return (
    <Paper
      onSubmit={handleSubmit(submitHandler)}
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
        <TextField
          control={control}
          name="email"
          label="البريد الإلكتروني"
          type="email"
        />
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
