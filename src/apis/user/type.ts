export type IGetAllUser = {
  totalPages: number;
  totalDataCount: number;
  pageNumber: number;
  data: [
    {
      id: string;
      firstName: string;
      lastName: string;
      dialCode: string;
      phoneNumber: string;
      email: string;
      scanStartDate: string;
    }
  ];
};

export type IGetUser = {
  id: string;
  type: string;
  category: 0;
  remainingScans: 0;
  startDate: string;
  endDate: string;
};

export type IGetAllUserParams = Partial<{
  Query: string;
  PageSize: number;
  PageNumber: number;
  IsDesc: boolean;
  TeacherGender: number;  
  ScanType: number; 
}>;

export type IAddUser = {
  firstName: string;
  lastName: string;
  phoneNumber: string;
  gender: number;
  dialCode: string;
  scanType:number
};

export type IAllSubscribtion = {
  id: string;
  key: string;
  value: number;
};

export type ITeachersCount = {
  allUsers: number;
  freeUsers: number;
  yearUnlimitedUsers: number;
  maleUsers: number;
  femaleUsers: number;
};

export type IAdminUser = {
  id: number;
  name: string;
  phone: string;
  email: string;
  fcm_token: string | null;
  profile_image: string | null;
  role: string;
  created_at: string;
  updated_at: string;
  deleted_at: string | null;
};

export type IAdminUsersPaginated = {
  current_page: number;
  data: IAdminUser[];
  first_page_url: string;
  from: number | null;
  last_page: number;
  last_page_url: string;
  next_page_url: string | null;
  path: string;
  per_page: number;
  prev_page_url: string | null;
  to: number | null;
  total: number;
};

export type IAdminUsersResponse = {
  status: string;
  data: IAdminUsersPaginated;
};

export type IGetAdminUsersParams = {
  search?: string;
  page?: number;
  per_page?: number;
};