import { useMutation } from "@tanstack/react-query";
import API from "./api";


const queries = {
  Login: () => useMutation({ mutationFn: API.login }),
};
export default queries;
