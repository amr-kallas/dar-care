import CheckCircleOutlineIcon from "@mui/icons-material/CheckCircleOutline";
import { IconButton, IconButtonProps, Tooltip } from "@mui/material";
import { FC } from "react";

type Props = IconButtonProps;

const ActivateIconButton: FC<Props> = (props) => {
  return (
    <Tooltip title={"تفعيل"}>
      <span>
        <IconButton {...props}>
          <CheckCircleOutlineIcon sx={{ color: "success.main" }} />
        </IconButton>
      </span>
    </Tooltip>
  );
};
export default ActivateIconButton;
