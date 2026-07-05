export interface APIList<T> {
  pageNumber: number;
  totalPages: number;
  totalDataCount: number;
  data: T[];
}

export type IPaginationType<T> = {
  pageParams: number[];
  pages: {
    totalPages: number;
    totalDataCount: number;
    pageNumber: number;
    data: T[];
  }[];
};