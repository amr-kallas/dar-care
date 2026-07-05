import HandymanOutlinedIcon from "@mui/icons-material/HandymanOutlined";
import MenuIcon from "@mui/icons-material/Menu";
import NotificationsNoneIcon from "@mui/icons-material/NotificationsNone";
import PeopleOutlineIcon from "@mui/icons-material/PeopleOutline";
import ReceiptLongOutlinedIcon from "@mui/icons-material/ReceiptLongOutlined";
import DesignServicesOutlinedIcon from "@mui/icons-material/DesignServicesOutlined";
import ReviewsOutlinedIcon from "@mui/icons-material/ReviewsOutlined";
import SupportAgentIcon from "@mui/icons-material/SupportAgent";
import { ReactNode } from "react";
export type SideBarItem = {
  href: string;
  text: string;
  icon: ReactNode;
  children?: SideBarItem[];
};
export const createSideBarItems = [
  [
    {
      href: "",
      icon: <MenuIcon />,
      text: "الرئيسية",
    },
    {
      href: "user",
      icon: <PeopleOutlineIcon />,
      text: "المستخدمين",
    },
    {
      href: "craftsmen",
      icon: <HandymanOutlinedIcon />,
      text: "الحرفيين",
    },
    {
      href: "notification",
      icon: <NotificationsNoneIcon />,
      text: "الإشعارات",
    },
    {
      href: "support",
      icon: <SupportAgentIcon />,
      text: "الدعم الفني",
    },
    {
      href: "orders",
      icon: <ReceiptLongOutlinedIcon />,
      text: "الطلبات",
    },
    {
      href: "service-categories",
      icon: <DesignServicesOutlinedIcon />,
      text: "الخدمات",
    },
    {
      href: "reviews",
      icon: <ReviewsOutlinedIcon />,
      text: "التقييمات",
    },
  ],
].filter((section) => section.length !== 0);
