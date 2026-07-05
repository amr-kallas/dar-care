import {
  Box,
  TableBody,
  TableCell,
  TableContainer,
  TableHeadProps,
} from "@mui/material";
import Paper, { PaperProps } from "@mui/material/Paper";
import { Stack } from "@mui/system";
import { UseInfiniteQueryResult } from "@tanstack/react-query";
import Skeleton, { SkeletonProps } from "@components/feedbacks/skeleton";
import SomethingWentWrong from "@components/feedbacks/somethingWentWrong";
import RepeatELement from "@components/layout/repeatElement";
import { FC, ReactElement, ReactNode } from "react";
import { APIList } from "../../../types/apiType";
import Loading from "@components/feedbacks/loading";
import NoData from "@components/feedbacks/noData";
import Table from "../TableWithAlign";
import PaginationButtons from "./PaginationButtons";
import TableRowStriped from "./TableRowStriped";
import { useHandlePageChange } from "./useHandlePageChange";
import usePageNumberSearchParam from "@hooks/usePageNumberSearchParam";
type Props = {
  infiniteQuery: UseInfiniteQueryResult<APIList<unknown>, unknown>;
  children: ReactNode;
  pageNumber: number;
  isInfinite?: boolean;
  tableHead: ReactElement<TableHeadProps>;
  search?: string;
} & PaperProps &
  (
    | {
        skeleton?: true;
        cellCount: number;
        rowCount?: number;
        skeletonProps?: SkeletonProps;
      }
    | {
        skeleton?: false;
        cellCount?: undefined;
        rowCount?: undefined;
        skeletonProps?: undefined;
      }
  );
const PaginationTable: FC<Props> = ({
  infiniteQuery,
  children,
  pageNumber,
  skeleton,
  skeletonProps,
  isInfinite = true,
  tableHead,
  search,
  cellCount,
  rowCount,
  ...props
}) => {
  const {
    fetchNextPage,
    fetchPreviousPage,
    data,
    isFetching,
    isSuccess,
    isError,
  } = infiniteQuery;
  const handlePageChange = useHandlePageChange({
    fetchNextPage,
    fetchPreviousPage,
    pages: [],
    isInfinite: isInfinite,
  });

  const { page } = usePageNumberSearchParam();
  const noData =
    (data?.pages ? !data?.pages[0]?.data?.length : !data?.data.length) &&
    isSuccess;

  return (
    <Paper
      {...props}
      sx={{ borderRadius: 2, mb: 6, overflow: "hidden", ...props.sx }}
    >
      <Stack>
        <TableContainer>
          <Table>
            {tableHead}
            {isSuccess && children}
            {isFetching &&
              (data?.pages ? !data?.pages?.[page]?.data : !data?.data) &&
              skeleton && (
                <RepeatELement
                  repeat={rowCount ?? 10}
                  container={<TableBody />}
                >
                  <RepeatELement
                    repeat={cellCount}
                    container={<TableRowStriped />}
                  >
                    <TableCell>
                      <Skeleton
                        widthRange={{ min: 20, max: 40 }}
                        height={30}
                        sx={{ m: "auto" }}
                        {...skeletonProps}
                      />
                    </TableCell>
                  </RepeatELement>
                </RepeatELement>
              )}
          </Table>
        </TableContainer>
        {isFetching && !skeleton && (
          <Box sx={{ mx: "auto", my: 2 }}>
            <Loading />
          </Box>
        )}

        {noData && (
          <Box sx={{ mx: "auto", my: 2 }}>
            <NoData />
          </Box>
        )}
        {isError && (
          <Box sx={{ mx: "auto", my: 2 }}>
            <SomethingWentWrong />
          </Box>
        )}
        {data && (
          <PaginationButtons
            page={pageNumber}
            handleChangePage={handlePageChange}
            data={data}
            search={search}
          />
        )}
      </Stack>
    </Paper>
  );
};

export default PaginationTable;
