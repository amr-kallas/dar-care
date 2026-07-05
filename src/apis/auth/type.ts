export type ILoginReq = {
  userName: string;
  password: string;
};

export type ILoginRes = {
  token: string;
  userId: string;
  roleId:string;
};
