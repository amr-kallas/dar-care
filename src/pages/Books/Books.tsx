// import { queries } from "@apis/user/queries";
import queries, { keys } from "@apis/QuesGenerator/query";
import AddFab from "@components/buttons/addFab";
import EditIconButton from "@components/buttons/EditIconButton";
import QuesIconButton from "@components/buttons/QuesIcon";
import RemoveIconButton from "@components/buttons/RemoveIconButton";
import ShowIconButton from "@components/buttons/ShowIconButton";
import RemoveDialog from "@components/forms/RemoveDialog";
import SearchFilter from "@components/inputs/searchFilter";
import ButtonsStack from "@components/layout/buttonStack";
import PaginationTable from "@components/tables/PaginationTable";
import TableRowStriped from "@components/tables/PaginationTable/TableRowStriped";
import useEventSearchParams from "@hooks/useEventSearchParams";
import usePageNumberSearchParam from "@hooks/usePageNumberSearchParam";
import useQuerySearchParam from "@hooks/useQuerySearchParam";
import {
  Grid,
  Stack,
  TableBody,
  TableCell,
  TableHead,
  TableRow
} from "@mui/material";
import { toisoString } from "@utils/function-helper";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { BookSAction } from "./BookActions";
import { Details } from "./details";

const columns = [
  "الاسم",
  "المدينة",
  "الصف",
  "تاريخ الانشاء ",
  "اللغة",
  "خيارات",
];
const lang = [
    'العربية',
    'الانجليزية'
]
const Books = () => {
  const navigate = useNavigate();
  const search = useQuerySearchParam();
  const { page, clearPageParams } = usePageNumberSearchParam();
  const { remove, details, edit } = useEventSearchParams();
  const { mutate, isPending } = queries.DeleteBook();
  useEffect(() => {
    query.refetch();
  }, [ search, page]);

  const query = queries.GetAllBooks({
    Query: search,
    PageNumber: page,
  });
  useEffect(() => {
    query.refetch(); 
  }, [ search, page ]);
 
  const { data } = query;



  useEffect(() => {
    clearPageParams();
  }, []);


  return (
    <Stack gap={1} padding={{ xs: 3, sm: 5 }}>
      <Grid
        container
        spacing={2}
        alignItems="center"
        sx={{ display: "flex", justifyContent: "flex-start" }}
      >
        <Grid item>
          <SearchFilter
            sx={{
              width: "200px",
              input: { paddingY: "12px" },
              marginBottom: "8px",
            }}
          />
        </Grid>
      </Grid>
      <PaginationTable
        pageNumber={page}
        search={search}
        tableHead={
          <TableHead
            sx={{
              ".MuiTableHead-root": {
                color: "red",
              },
            }}
          >
            <TableRow>
              {columns.map((cellHeader, index) => (
                <TableCell
                  key={cellHeader}
                  sx={{
                    color:
                      cellHeader === "تاريخ الاشتراك" ? "white" : "inherit",
                    ...(index === 0 && {
                      "&.MuiTableCell-root": { pl: 6, textAlign: "center" },
                    }),
                    ".MuiTableSortLabel-root": {
                      color: "white !important",
                    },
                    svg: {
                      color: "white !important",
                    },
                  }}
                >
                  {cellHeader}
                </TableCell>
              ))}
            </TableRow>
          </TableHead>
        }
        skeleton={true}
        isInfinite={false}
        cellCount={columns.length}
        infiniteQuery={query}
      >
        <TableBody>
          {data?.data?.map((book) => {
            return (
              <TableRowStriped key={book.id}>
                <TableCell>{book.title}</TableCell>
                <TableCell>{book.country}</TableCell>
                <TableCell>{book.className} </TableCell>
                <TableCell>
                  {book.createdAt
                    ? toisoString(new Date(book.createdAt)).slice(0, 10)
                    : "_"}
                </TableCell>
                <TableCell>{lang[Number(book.language)]} </TableCell>

                <TableCell>
                  <ButtonsStack>
                    <ShowIconButton onClick={() => details(book.id)} />
                    <RemoveIconButton onClick={() => remove(book.id)} />
                    <EditIconButton onClick={() => edit(book.id)} />
                    <QuesIconButton onClick={() => navigate('Ques/' + book.id)} />
                  </ButtonsStack>
                </TableCell>
              </TableRowStriped>
            );
          })}
        </TableBody>
      </PaginationTable>
            <Details />      
          <AddFab />
      <BookSAction/>
      <RemoveDialog
        mutateFn={mutate}
        invalidateQueryKey={keys.getBook._def}
        isPending={isPending}
      />
      {/* <AddSubscription /> */}
    </Stack>
  );
};
export default Books;
