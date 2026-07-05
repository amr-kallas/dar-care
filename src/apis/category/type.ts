export type IAdminCategory = {
  id: number;
  name: string;
  slug: string;
  icon: string;
  description: string | null;
  is_active: number;
  created_at: string;
  updated_at: string;
  providers_count: number;
};

export type IAdminCategoriesResponse = {
  status: string;
  data: IAdminCategory[];
};

export type ICategoryBody = {
  name: string;
  slug: string;
  icon: string;
  description?: string | null;
  is_active: number;
};

export type ISaveCategoryInput = ICategoryBody & {
  id?: string;
};
