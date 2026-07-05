import { Navigate, Outlet } from "react-router-dom";

const Auth = () => {
  const token = localStorage.getItem("token");
  if (true) return <Outlet />;
  return <Navigate to="/login" />;
};
export default Auth;
