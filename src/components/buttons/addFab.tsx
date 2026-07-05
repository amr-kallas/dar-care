import AddIcon from "@mui/icons-material/Add";
import { Fab, FabProps, Tooltip } from "@mui/material";
import { FC } from "react";
import { useSearchParams } from "react-router-dom";
type Props = FabProps;
const AddFab: FC<Props> = (props) => {
  const [searchParams, setSearchParams] = useSearchParams();
  const handleClick = () => {
    searchParams.set("mode", "add");
    setSearchParams(searchParams);
  };
  return (
    <Tooltip title={"إضافة"}>
      <Fab
        color="primary"
        onClick={handleClick}
        sx={{
          position: "fixed",
          top: "89%",
          right: 16,
          ":hover": {
            backgroundColor: "primary.main",
          },
        }}
        {...props}
      >
        <AddIcon sx={{ color: "white" }} />
      </Fab>
    </Tooltip>
  );
};
export default AddFab;
