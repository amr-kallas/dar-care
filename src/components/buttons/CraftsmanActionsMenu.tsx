import MoreVertIcon from "@mui/icons-material/MoreVert";
import VisibilityIcon from "@mui/icons-material/Visibility";
import BlockIcon from "@mui/icons-material/Block";
import CheckIcon from "@mui/icons-material/Check";
import CheckCircleOutlineIcon from "@mui/icons-material/CheckCircleOutline";
import HighlightOffIcon from "@mui/icons-material/HighlightOff";
import {
  IconButton,
  ListItemIcon,
  ListItemText,
  Menu,
  MenuItem,
  Tooltip,
} from "@mui/material";
import { FC, MouseEvent, useState } from "react";

type Props = {
  onDetails: () => void;
  onStop: () => void;
  onActivate: () => void;
  /** Drives whether the row offers إيقاف or تفعيل for the account status. */
  isActive: boolean;
  onApprove: () => void;
  onReject: () => void;
  /** Verification actions are hidden once they no longer apply. */
  showApprove?: boolean;
  showReject?: boolean;
};

const CraftsmanActionsMenu: FC<Props> = ({
  onDetails,
  onStop,
  onActivate,
  isActive,
  onApprove,
  onReject,
  showApprove = true,
  showReject = true,
}) => {
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const isOpen = Boolean(anchorEl);

  const handleOpen = (event: MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  // Close first so the menu is gone before the dialog takes over the screen.
  const handleSelect = (action: () => void) => () => {
    handleClose();
    action();
  };

  return (
    <>
      <Tooltip title={"خيارات"}>
        <span>
          <IconButton
            onClick={handleOpen}
            aria-haspopup="true"
            aria-expanded={isOpen ? "true" : undefined}
          >
            <MoreVertIcon sx={{ color: "primary.main" }} />
          </IconButton>
        </span>
      </Tooltip>
      <Menu
        anchorEl={anchorEl}
        open={isOpen}
        onClose={handleClose}
        anchorOrigin={{ vertical: "bottom", horizontal: "left" }}
        transformOrigin={{ vertical: "top", horizontal: "left" }}
      >
        <MenuItem onClick={handleSelect(onDetails)}>
          <ListItemIcon>
            <VisibilityIcon fontSize="small" sx={{ color: "primary.main" }} />
          </ListItemIcon>
          <ListItemText>التفاصيل</ListItemText>
        </MenuItem>
        {isActive ? (
          <MenuItem onClick={handleSelect(onStop)}>
            <ListItemIcon>
              <BlockIcon fontSize="small" sx={{ color: "warning.main" }} />
            </ListItemIcon>
            <ListItemText>إيقاف الحرفي</ListItemText>
          </MenuItem>
        ) : (
          <MenuItem onClick={handleSelect(onActivate)}>
            <ListItemIcon>
              <CheckIcon fontSize="small" sx={{ color: "success.main" }} />
            </ListItemIcon>
            <ListItemText>تفعيل الحرفي</ListItemText>
          </MenuItem>
        )}
        {showApprove && (
          <MenuItem onClick={handleSelect(onApprove)}>
            <ListItemIcon>
              <CheckCircleOutlineIcon
                fontSize="small"
                sx={{ color: "success.main" }}
              />
            </ListItemIcon>
            <ListItemText>قبول الحرفي</ListItemText>
          </MenuItem>
        )}
        {showReject && (
          <MenuItem onClick={handleSelect(onReject)}>
            <ListItemIcon>
              <HighlightOffIcon fontSize="small" sx={{ color: "error.main" }} />
            </ListItemIcon>
            <ListItemText>رفض الحرفي</ListItemText>
          </MenuItem>
        )}
      </Menu>
    </>
  );
};

export default CraftsmanActionsMenu;
