import BlockIcon from "@mui/icons-material/Block";
import { IconButton, IconButtonProps, Tooltip } from "@mui/material";
import { FC } from "react";

type Props = IconButtonProps;

const StopIconButton: FC<Props> = (props) => {
  return (
    <Tooltip title={"إيقاف"}>
      <span>
        <IconButton {...props}>
          <BlockIcon sx={{ color: "warning.main" }} />
        </IconButton>
      </span>
    </Tooltip>
  );
};
export default StopIconButton;
