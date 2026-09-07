import { useSnackbar } from "@context/snackbarContext";
import { ReactNode } from "react";
const useErrorSnackbar = () => {
  const snackbar = useSnackbar();
  return function (message: ReactNode) {
    snackbar({ message, severity: "error" });
  };
};
export default useErrorSnackbar;
