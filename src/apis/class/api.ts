import axios from "@lib/axios";
import { IGetAllClass, IGetAllClassParams, IGetClass, ISetClass } from "./type";
import API_ROUTES from "@constants/apiRoutes";

export const API = {
  getAllClass: async (params: IGetAllClassParams) => {
    const { data } = await axios<IGetAllClass>(API_ROUTES.CLASS.GET_ALL_CLASS, {
      params,
    });
    return data;
  },
  getClass: async (Id: string) => {
    const { data } = await axios<IGetClass>(API_ROUTES.CLASS.GET_CLASS, {
      params: { Id },
    });
    return data;
  },
  setClass: async (body: ISetClass) => {
    const { data } = await axios.post(API_ROUTES.CLASS.SET_CLASS, {
      ...body,
      id: "00000000-0000-0000-0000-000000000000",
    });
    return data;
  },
};
