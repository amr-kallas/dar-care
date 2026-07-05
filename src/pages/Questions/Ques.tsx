// import { queries } from "@apis/user/queries";
import queries, { keys } from "@apis/QuesGenerator/query";
import AddFab from "@components/buttons/addFab";
import EditIconButton from "@components/buttons/EditIconButton";
import RemoveIconButton from "@components/buttons/RemoveIconButton";
import ShowIconButton from "@components/buttons/ShowIconButton";
import RemoveDialog from "@components/forms/RemoveDialog";
import SearchFilter from "@components/inputs/searchFilter";
import { Select } from "@components/inputs/select";
import ButtonsStack from "@components/layout/buttonStack";
import PaginationTable from "@components/tables/PaginationTable";
import TableRowStriped from "@components/tables/PaginationTable/TableRowStriped";
import useEventSearchParams from "@hooks/useEventSearchParams";
import usePageNumberSearchParam from "@hooks/usePageNumberSearchParam";
import useQuerySearchParam from "@hooks/useQuerySearchParam";
import { ArrowBack } from "@mui/icons-material";
import {
  Fab,
  FormControl,
  Grid,
  MenuItem,
  Stack,
  TableBody,
  TableCell,
  TableHead,
  TableRow,
  Tooltip,
} from "@mui/material";
import { useEffect, useState } from "react";
import { useForm } from "react-hook-form";
import { useNavigate, useParams } from "react-router-dom";
import { AddQues } from "./AddQues";
import { Details } from "./details";
import { EditQues } from "./editQues";

const columns = [
  "السؤال",
  "النوع",
  "الصعوبة",
  "صفحة السؤال",
  "خيارات",
];
export const questionTypes = ["اختيار من متعدد", "كتابي", "توصيل", "صح و خطأ"];
 export const questionDifficulty = ["سهل ", "متوسط ", "صعب "];
const Ques = () => {
  const navigate = useNavigate()
  const [Difficulty, setDifficulty] = useState<number>()
  const [Type, setType] = useState<number>()
  const {control}= useForm()
  const { id } = useParams();
  const [sortOrder, setSortOrder] = useState(true);
  const search = useQuerySearchParam();
  const { page, clearPageParams } = usePageNumberSearchParam();
  const { remove, details, edit } = useEventSearchParams();
  const { mutate, isPending } = queries.DeleteQues();
  useEffect(() => {
    query.refetch();
  }, [search, page, sortOrder]);

  const query = queries.GetAllQues({
    Query: search,
    PageNumber: page,
    BookId: id,
    Difficulty,
    Type
  });
  useEffect(() => {
    query.refetch();
  }, [search, page, sortOrder]);

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
        <Grid item>
          <FormControl sx={{ width: "200px", height: "60px" }}>
            <Select
              control={control}
              name="Difficulty"
              label="الصعوبة"
              onChange={(value) => setDifficulty(+value)}
            >
              <MenuItem value={0}>سهل</MenuItem>
              <MenuItem value={1}>متوسط</MenuItem>
              <MenuItem value={2}>صعب</MenuItem>
            </Select>
          </FormControl>
        </Grid>
        <Grid item>
          <FormControl sx={{ width: "200px", height: "60px" }}>
            <Select
              control={control}
              name="Type"
              label="النوع"
              onChange={(value) => setType(+value)}
            >
              <MenuItem value={0}>اختيار من متعدد</MenuItem>
              <MenuItem value={1}>كتابي</MenuItem>
              <MenuItem value={2}>توصيل</MenuItem>
              <MenuItem value={3}>صح وخطأ</MenuItem>
            </Select>
          </FormControl>
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
                <TableCell>{questionTypes[book.type]}</TableCell>
                <TableCell>{questionDifficulty[book.difficulty]} </TableCell>
                <TableCell>{book.pageNumber} </TableCell>

                <TableCell>
                  <ButtonsStack>
                    <ShowIconButton onClick={() => details(book.id)} />
                    <RemoveIconButton onClick={() => remove(book.id)} />
                    <EditIconButton onClick={() => edit(book.id)} />
                  </ButtonsStack>
                </TableCell>
              </TableRowStriped>
            );
          })}
        </TableBody>
      </PaginationTable>
      <Details />
      <EditQues/>
      <AddFab />
      <AddQues />
      <RemoveDialog
        mutateFn={mutate}
        invalidateQueryKey={keys.getBook._def}
        isPending={isPending}
      />
      <Tooltip
        title={"رجوع"}
        sx={{
          position: "fixed",
          bottom: 10,
          right: 16,
          ":hover": {
            backgroundColor: "primary.main",
          },
        }}
      >
        <Fab color="primary" onClick={() => navigate("/books")}>
          <ArrowBack sx={{ color: "white" }} />
        </Fab>
      </Tooltip>
    </Stack>
  );
};
export default Ques;
