import { AutocompleteProps, TextFieldProps } from "@mui/material";
import TextField from "@components/inputs/textField";
import React, { FC } from "react";
import { Control, Controller } from "react-hook-form";
import Skeleton from "@components/feedbacks/skeleton";
export type AutocompleteControlProps = {
  name: string;
  control: Control<any>;
  label: string;
  textFieldProps?: TextFieldProps;
  required?: boolean;
  disabled?: boolean;
  isLoading?:boolean;
  children: React.ReactElement<AutocompleteProps<any, any, any, any, any>>;
};
const AutocompleteControl: FC<AutocompleteControlProps> = ({
  name,
  control,
  label,
  required = false,
  children,
  isLoading,
  disabled = false,
  textFieldProps,
}) => {
  return (
    <Controller
      name={name}
      control={control}
      render={({ field, fieldState }) =>
        React.cloneElement(children, {
          ...children.props,
          value: field.value || [],
          onChange: (_, value) => {
            if (Array.isArray(value)) {
              const uniqueValues = Array.from(
                new Map(value.map((item: any) => [item.id, item])).values()
              );
              field.onChange(uniqueValues);
            } else {
              field.onChange(value);
            }
          },
          disabled: disabled,
          // onChange: (_, value) => field.onChange(value),
          renderInput: (params) => (
            <>
              {isLoading ? (
                <Skeleton
                  variant="rectangular"
                  width="100%"
                  height={56}
                  sx={{ borderRadius: 1 }}
                />
              ) : (
                <TextField
                  {...params}
                  {...textFieldProps}
                  label={label}
                  required={required}
                  error={!!fieldState.error}
                  helperText={fieldState.error?.message}
                />
              )}
            </>
          ),
        } as AutocompleteProps<any, any, any, any, any>)
      }
    />
  );
};
export default AutocompleteControl;
