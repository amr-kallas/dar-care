import { createQueryKeys } from "@lukemorales/query-key-factory";
import { API } from "./api";
import { IGetAllClassParams } from "./type";
import { useMutation, useQuery } from "@tanstack/react-query";



export const keys = createQueryKeys("class", {
  getAllClass: (params: IGetAllClassParams) => ({
    queryFn: () => API.getAllClass(params),
    queryKey: [params],
    }),
    getClass: (Id: string) => ({
        queryFn: () => API.getClass(Id),
        queryKey:[Id]
    }),
    
});

const queries = {
    GetAllClass: (params: IGetAllClassParams) => useQuery(keys.getAllClass(params)),
    GetClass: (Id: string) => useQuery({ ...keys.getClass(Id), enabled: !!Id }),
    SetClass:()=>useMutation({mutationFn:API.setClass})
}

export default queries