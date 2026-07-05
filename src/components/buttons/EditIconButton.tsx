import EditIcon from "@mui/icons-material/Edit";
import { IconButton, IconButtonProps, Tooltip } from "@mui/material";
import { FC } from "react";
type Props = IconButtonProps;
const EditIconButton: FC<Props> = (props) => {
  return (
    <Tooltip title={"تعديل"}>
      <IconButton {...props}>
        <EditIcon sx={{ color: "success.main" }} />
      </IconButton>
    </Tooltip>
  );
};
export default EditIconButton;
