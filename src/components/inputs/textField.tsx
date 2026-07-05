import Skeleton from "@components/feedbacks/skeleton";
import {
  styled,
  TextField as MuiTextField,
  TextFieldProps as MuiTextFieldProps,
} from "@mui/material";
import { Control, Controller } from "react-hook-form";
const TextFieldStyled = styled(MuiTextField, {
  shouldForwardProp: (prop) => prop !== "required",
})(({ required, theme }) => ({
  paddingLeft: 3,
  label: {
    color: theme.palette.primary.main,
  },
  "label::after": {
    content: required ? '"*"' : '""',
    padding: "1px",
    color: theme.palette.error.main,
  },
}));
export type TextFieldProps<controlled extends boolean = false> = MuiTextFieldProps &
  (controlled extends true
    ? {
        name: string;
        control: Control<any>;
        isLoading?: boolean;
      }
    : { control?: undefined; isLoading?: boolean });

export const TextField = ({
  control,
  name,
  isLoading,
  ...props
}: TextFieldProps<true | false>) => {
  if (control) {
    return (
      <Controller
        name={name}
        control={control}
        render={({ field, fieldState: { error } }) => (
          <>
            {isLoading ? (
              <Skeleton
                variant="rectangular"
                width="100%"
                height={56}
                sx={{ borderRadius: 1 }}
              />
            ) : (
              <TextFieldStyled
                fullWidth
                error={!!error}
                helperText={error && error.message}
                {...field}
                {...props}
              />
            )}
          </>
        )}
      />
    );
  }
  return <TextFieldStyled fullWidth {...props} />;
};
export default TextField;
