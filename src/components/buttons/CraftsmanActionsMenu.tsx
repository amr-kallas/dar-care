import MoreVertIcon from "@mui/icons-material/MoreVert";
import VisibilityIcon from "@mui/icons-material/Visibility";
import BlockIcon from "@mui/icons-material/Block";
import CheckIcon from "@mui/icons-material/Check";
import CheckCircleOutlineIcon from "@mui/icons-material/CheckCircleOutline";
import HighlightOffIcon from "@mui/icons-material/HighlightOff";
import DeleteOutlineIcon from "@mui/icons-material/DeleteOutline";
import { Divider } from "@mui/material";
import {
  IconButton,
  ListItemIcon,
  ListItemText,
  Menu,
  MenuItem,
  Tooltip,
} from "@mui/material";
import { FC, MouseEvent, ReactNode, useState } from "react";

type Props = {
  onDetails: () => void;
  onStop: () => void;
  onActivate: () => void;
  /** Drives whether the row offers إيقاف or تفعيل for the account status. */
  isActive: boolean;
  onApprove: () => void;
  onReject: () => void;
  onRemove: () => void;
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
  onRemove,
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

  // Built as a list so every row gets the same padding and one divider sits
  // between each pair, regardless of which rows the craftsman's state hides.
  const items = [
    {
      key: "details",
      label: "التفاصيل",
      icon: <VisibilityIcon fontSize="small" sx={{ color: "primary.main" }} />,
      onClick: onDetails,
    },
    isActive
      ? {
          key: "stop",
          label: "إيقاف الحرفي",
          icon: <BlockIcon fontSize="small" sx={{ color: "warning.main" }} />,
          onClick: onStop,
        }
      : {
          key: "activate",
          label: "تفعيل الحرفي",
          icon: <CheckIcon fontSize="small" sx={{ color: "success.main" }} />,
          onClick: onActivate,
        },
    ...(showApprove
      ? [
          {
            key: "approve",
            label: "قبول الحرفي",
            icon: (
              <CheckCircleOutlineIcon
                fontSize="small"
                sx={{ color: "success.main" }}
              />
            ),
            onClick: onApprove,
          },
        ]
      : []),
    ...(showReject
      ? [
          {
            key: "reject",
            label: "رفض الحرفي",
            icon: (
              <HighlightOffIcon fontSize="small" sx={{ color: "error.main" }} />
            ),
            onClick: onReject,
          },
        ]
      : []),
    {
      key: "remove",
      label: "حذف الحرفي",
      icon: (
        <DeleteOutlineIcon fontSize="small" sx={{ color: "error.main" }} />
      ),
      onClick: onRemove,
      color: "error.main",
    },
  ] as {
    key: string;
    label: string;
    icon: ReactNode;
    onClick: () => void;
    color?: string;
  }[];

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
        // overflow:hidden clips the row hover fill to the paper's rounded
        // corners, which otherwise leaves a gap under the last row.
        slotProps={{ paper: { sx: { minWidth: 210, overflow: "hidden" } } }}
        MenuListProps={{ sx: { pt: 1, pb: 0 } }}
      >
        {items.map((item, index) => [
          index > 0 && <Divider key={`${item.key}-divider`} sx={{ my: 0 }} />,
          <MenuItem
            key={item.key}
            onClick={handleSelect(item.onClick)}
            sx={{ py: 0.5, minHeight: 40 }}
          >
            <ListItemIcon sx={{ minWidth: 34 }}>{item.icon}</ListItemIcon>
            <ListItemText sx={{ my: 0, color: item.color }}>
              {item.label}
            </ListItemText>
          </MenuItem>,
        ])}
      </Menu>
    </>
  );
};

export default CraftsmanActionsMenu;
