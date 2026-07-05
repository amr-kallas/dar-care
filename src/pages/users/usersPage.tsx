import { Stack } from "@mui/material";
import UsersList from "./usersList";

const UsersPage = () => (
  <Stack gap={1} padding={{ xs: 3, sm: 5 }}>
    <UsersList />
  </Stack>
);

export default UsersPage;
