import { useSearchParams } from "react-router-dom";

const useStopSearchParams = (idKey = "id", stopKey = "stop") => {
  const [searchParams, setSearchParams] = useSearchParams();
  const isActive = searchParams.get("mode") === stopKey;
  const id = searchParams.get(idKey);
  const clearStopParams = () => {
    searchParams.delete(idKey);
    searchParams.delete("mode");
    setSearchParams(searchParams);
  };
  return { id, isActive, clearStopParams };
};
export default useStopSearchParams;
