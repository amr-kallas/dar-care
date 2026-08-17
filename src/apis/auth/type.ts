export type ILoginReq = {
  email: string;
  password: string;
};

export type ILoginUser = {
  id: number;
  name?: string;
  email?: string;
  phone?: string;
  role?: string;
};

export type ILoginRes = {
  success?: boolean;
  message?: string;
  errors?: unknown;
  status?: string;
  token?: string;
  access_token?: string;
  data?: {
    token?: string;
    access_token?: string;
    admin?: ILoginUser;
    user?: ILoginUser;
  };
  user?: ILoginUser;
};
