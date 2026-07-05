import Skeleton from "@components/feedbacks/skeleton";
import {
  FormControl,
  FormHelperText,
  InputLabel,
  Select as MuiSelect,
  SelectProps as Props,
} from "@mui/material";
import { Control, Controller } from "react-hook-form";
export type SelectProps = {
  onClear?: () => void;
  name: string;
  control: Control<any>;
  children: React.ReactNode;
  isLoading?: boolean;
} & Props;

export function Select({ control, label, children, name, onChange , isLoading }: SelectProps) {
  return (
    <FormControl sx={{ m: 0, minWidth: 120, width: 1 }} size="small">
      <InputLabel id={`${name}-label`} sx={{ mt: "5px" }}>
        {label}
      </InputLabel>
      {isLoading ? (
        <Skeleton
          variant="rectangular"
          width="100%"
          height={56}
          sx={{ borderRadius: 1 }}
        />
      ) : (
        <Controller
          name={name}
          control={control}
          defaultValue={null}
          render={({ field, fieldState: { error } }) => (
            <>
              <MuiSelect
                {...field}
                value={field.value ?? ""}
                labelId={`${name}-label`}
                error={!!error?.message}
                onChange={(e) => {
                  const selectedValue =
                    e.target.value === "" ? null : Number(e.target.value);
                  field.onChange(selectedValue);
                  if (onChange) onChange(selectedValue);
                }}
                displayEmpty
                sx={{
                  ".MuiSelect-select": {
                    padding: "16px 0 16px 14px !important",
                  },
                }}
              >
                {children}
              </MuiSelect>
              <FormHelperText sx={{ color: "error.main" }}>
                {error?.message}
              </FormHelperText>
            </>
          )}
        />
      )}
    </FormControl>
  );
}

