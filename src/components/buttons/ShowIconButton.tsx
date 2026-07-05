import VisibilityIcon from "@mui/icons-material/Visibility";
import { IconButton, IconButtonProps, Tooltip } from "@mui/material";
import { FC } from "react";
type Props = IconButtonProps;
const ShowIconButton: FC<Props> = (props) => {
  return (
    <Tooltip title={"التفاصيل"}>
      <IconButton {...props}>
        <VisibilityIcon sx={{ color: "grey.700" }} />
      </IconButton>
    </Tooltip>
  );
};
export default ShowIconButton;
