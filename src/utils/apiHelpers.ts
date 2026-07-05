import { InfiniteData } from "@tanstack/react-query";
import { APIList } from "../types/apiType";

type Data<T> = InfiniteData<APIList<T>> | undefined;
export function getPage<T>(data: Data<T>, pageNumber: number) {
  return data?.pages[(data?.pageParams[pageNumber] as any) ?? 0]?.data ?? [];
}
