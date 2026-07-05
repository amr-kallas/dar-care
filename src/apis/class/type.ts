export type IGetAllClassParams = {
    Filter: boolean;  
}

export type IGetClass = {
  id: string;
  name: string;
};

export type IGetAllClass = IGetClass[];

export type ISetClass = {
    id: string ;
    name:{en:string, ar:string}
}
