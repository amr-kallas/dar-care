import { useSearchParams } from "react-router-dom";

function usePageNumberSearchParam(key = "p") {
  const [searchParams, setSearchParams] = useSearchParams();
  const clearPageParams = () => {
    searchParams.delete(key);
    setSearchParams(searchParams);
  };
  const page = Number(searchParams.get(key) ?? 0);
  return { page, clearPageParams };
}
export default usePageNumberSearchParam;
