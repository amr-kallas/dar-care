import { Navigate, Outlet } from "react-router-dom";

const NotAuth = () => {
  const token = localStorage.getItem("token");
  if (!token) return <Outlet />;
  return <Navigate to="/" />;
};
export default NotAuth;
