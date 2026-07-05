import { Controller } from "react-hook-form";
import {
  TextField as MuiTextField,
  InputAdornment,
  IconButton,
} from "@mui/material";
import UploadFileIcon from "@mui/icons-material/UploadFile";

interface FileInputProps {
  control: any;
  name: string;
  label: string;
  disabled: string;
}

export const FileInput: FC<FileInputProps> = ({ control, name, label, disabled }) => {
  return (
    <Controller
      name={name}
      control={control}
      render={({ field, fieldState }) => (
        <MuiTextField
          type="file"
          label={label}
          fullWidth
          disabled={disabled}
          error={!!fieldState.error}
          helperText={fieldState.error?.message}
          InputLabelProps={{ shrink: true }}
          inputProps={{ accept: ".pdf,.doc,.docx,image/*" }}
          onChange={(e) => field.onChange(e.target.files?.[0])}
          InputProps={{
            endAdornment: (
              <InputAdornment position="end">
                <IconButton component="span">
                  <UploadFileIcon />
                </IconButton>
              </InputAdornment>
            ),
          }}
        />
      )}
    />
  );
};
