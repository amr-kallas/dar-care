import { Button, ButtonProps, SxProps } from "@mui/material";
import { Box } from "@mui/system";
import Loading from "@components/feedbacks/loading";
import { RefObject, forwardRef } from "react";
export type SubmitProps = {
  isSubmitting?: boolean;
  error?: boolean;
  loadingSize?: number;
} & ButtonProps;
const defaultSx: SxProps = {
  fontSize: { xs: 15, sm: 20 },
  minWidth: 110,
};
const Submit = forwardRef(function Fr(
  {
    isSubmitting = false,
    error = false,
    disabled,
    loadingSize = 30,
    children,
    sx,
    ...props
  }: SubmitProps,
  ref
) {
  return (
    <Button
      ref={ref as RefObject<any>}
      disabled={isSubmitting || error || disabled}
      variant="contained"
      type="submit"
      {...props}
      sx={{
        ...defaultSx,
        position: "relative",
        bgcolor: error ? "error.main" : "",
        ":hover": {
          backgroundColor: "primary.main",
        },
        ...sx,
      }}
    >
      {isSubmitting && (
        <Box sx={{ position: "absolute", inset: 0 }}>
          <Loading stackProps={{ sx: { height: "100%" } }} size={loadingSize} />
        </Box>
      )}
      <Box sx={{ opacity: isSubmitting ? 0 : 1 }}>{children ?? "إضافة"}</Box>
    </Button>
  );
});
export default Submit;
