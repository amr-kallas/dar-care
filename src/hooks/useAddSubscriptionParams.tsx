import { useSearchParams } from "react-router-dom";

const useAddSubscriptionParams = ({  addSubKey = "addSub" } = {}) => {
  const [searchParams, setSearchParams] = useSearchParams();

  const isActive = searchParams.get("mode") === addSubKey;
  const clearSubscriptionParams = () => {
    searchParams.delete("mode");
    setSearchParams(searchParams);
  };
  return {  isActive, clearSubscriptionParams };
};
export default useAddSubscriptionParams;
