import MailIcon from "@mui/icons-material/Mail";
import { FC } from "react";
import TextField from "./textField";
import { InputAdornment } from "@mui/material";
type Props = TextFieldProps<true>;
export const EmailInput: FC<Props> = ({ control, name, ...props }) => {

  return (
    <TextField
      name={name}
      variant="outlined"
      control={control}
      label={"البريد الالكتروني "}
      fullWidth
      InputProps={{
        endAdornment: (
          <InputAdornment position="end">
            <MailIcon />
          </InputAdornment>
        ),
      }}
      {...props}
    />
  );
};

export default EmailInput;
