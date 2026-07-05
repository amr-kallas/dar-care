import { createQueryKeys } from "@lukemorales/query-key-factory";
import { useMutation, useQuery } from "@tanstack/react-query";
import API from "./api";
import type { ISaveCategoryInput } from "./type";

export const keys = createQueryKeys("category", {
  getAdminCategories: {
    queryFn: () => API.getAdminCategories(),
    queryKey: null,
  },
});

export const queries = {
  GetAdminCategories: () => useQuery(keys.getAdminCategories),
  saveCategory: () =>
    useMutation({
      mutationFn: ({ id, ...body }: ISaveCategoryInput) =>
        id ? API.updateCategory(id, body) : API.createCategory(body),
    }),
  deleteCategory: () => useMutation({ mutationFn: API.deleteCategory }),
};
