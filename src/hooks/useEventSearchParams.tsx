import { useSearchParams } from "react-router-dom";

const useEventSearchParams = ({
  detailsKey = "details",
  editKey = "edit",
  removeKey = "remove",
  stopKey = "stop",
  addSubKey = "addSub",
} = {}) => {
  const [searchParams, setSearchParams] = useSearchParams();

  const edit = (id: string) => {
    searchParams.set("id", id);
    searchParams.set("mode", editKey);
    setSearchParams(searchParams);
  };
  const details = (id: string) => {
    searchParams.set("id", id);
    searchParams.set("mode", detailsKey);
    setSearchParams(searchParams);
  };
  const remove = (id: string) => {
    searchParams.set("id", id);
    searchParams.set("mode", removeKey);
    setSearchParams(searchParams);
  };
  const stop = (id: string) => {
    searchParams.set("id", id);
    searchParams.set("mode", stopKey);
    setSearchParams(searchParams);
  };
  const addSubscription = () => { 
    searchParams.set("mode", addSubKey);
    setSearchParams(searchParams);
  }

  return { edit, details, remove, stop, addSubscription };
};
export default useEventSearchParams;
