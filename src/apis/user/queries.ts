import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useMutation, useQuery } from "@tanstack/react-query";
import API from "./api";
import { IGetAdminUsersParams, IGetAllUserParams } from "./type";

export const keys = createQueryKeys("user", {
  getAdminUsers: (params: IGetAdminUsersParams) => ({
    queryFn: () => API.getAdminUsers(params),
    queryKey: [params],
  }),
  getUsers: (params: IGetAllUserParams) => ({
    queryFn: () => API.getAll(params),
    queryKey: [params],
  }),
  getUser: (id: string) => ({
    queryFn: () => API.getUser(id),
    queryKey: [id],
  }),

  getSubscribtion: () => ({
    queryFn: () => API.getAllSubscribtion(),
    queryKey: [""],
  }),
  getTeachersCount: () => ({
    queryFn: () => API.getTeachersCount(),
    queryKey: ["getTeachersCount"],
  }),
});
export const queries = {
  GetAdminUsers: (params: IGetAdminUsersParams) =>
    useQuery(keys.getAdminUsers(params)),
  GetAllUsers: (params: IGetAllUserParams) => useQuery(keys.getUsers(params)),
  GetUser: (id: string) => useQuery({ ...keys.getUser(id), enabled: !!id }),
  GetTeachersCount: () => useQuery(keys.getTeachersCount()),
  AddUser: () => useMutation({ mutationFn: API.addUser }),
  deleteUser: () => useMutation({ mutationFn: API.deleteAdminUser }),
  GetSubscribtion: () => useQuery({ ...keys.getSubscribtion() }),
  AddSubscribtion: () => useMutation({ mutationFn: API.addSubscribtion }),
};
 