import DeleteIcon from "@mui/icons-material/Delete";
import { IconButton, IconButtonProps, Tooltip } from "@mui/material";
import { FC } from "react";
type Props = IconButtonProps;
const RemoveIconButton: FC<Props> = (props) => {
  return (
    <Tooltip title={"حذف"}>
      <IconButton {...props}>
        <DeleteIcon sx={{ color: "error.main" }} />
      </IconButton>
    </Tooltip>
  );
};
export default RemoveIconButton;
