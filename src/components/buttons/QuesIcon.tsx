import ListAltIcon from "@mui/icons-material/ListAlt";
import { IconButton, IconButtonProps, Tooltip } from "@mui/material";
import { FC } from "react";
type Props = IconButtonProps;
const QuesIconButton: FC<Props> = (props) => {
  return (
    <Tooltip title={"الاسئلة"}>
      <IconButton {...props}>
        <ListAltIcon sx={{ color: "success.main" }} />
      </IconButton>
    </Tooltip>
  );
};
export default QuesIconButton;
