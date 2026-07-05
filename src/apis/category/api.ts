import API_ROUTES from "@constants/apiRoutes";
import axios from "@lib/axios";
import {
  IAdminCategoriesResponse,
  IAdminCategory,
  ICategoryBody,
} from "./type";

const API = {
  getAdminCategories: async (): Promise<IAdminCategory[]> => {
    const { data } = await axios.get<IAdminCategoriesResponse>(
      API_ROUTES.ADMIN.GET_CATEGORIES
    );
    return data.data;
  },
  createCategory: async (body: ICategoryBody) => {
    const { data } = await axios.post(API_ROUTES.ADMIN.GET_CATEGORIES, body);
    return data;
  },
  updateCategory: async (id: string, body: ICategoryBody) => {
    const { data } = await axios.put(API_ROUTES.ADMIN.UPDATE_CATEGORY(id), body);
    return data;
  },
  deleteCategory: async (id: string) => {
    const { data } = await axios.delete(API_ROUTES.ADMIN.DELETE_CATEGORY(id));
    return data;
  },
};

export default API;
