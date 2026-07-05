import TablePagination from "@mui/material/TablePagination";
import { useEffect } from "react";

interface PaginationTableProps {
  data?: any;
  page: number;
  search?: string;
  handleChangePage: (
    event: React.MouseEvent<HTMLButtonElement> | null,
    newPage: number
  ) => void;
}

const PaginationButtons = ({
  data,
  page,
  search,
  handleChangePage,
}: PaginationTableProps) => {
  const PAGE_SIZE = 10;
  const isDisabled = !data;

  useEffect(() => {
    if (search && search !== "" && page !== 0) {
      handleChangePage(null, 0);
    }
  }, [search, handleChangePage, page]);

  return (
    <TablePagination
      rowsPerPageOptions={[
        data?.pages ? data?.pages[0].data.length : data?.data?.length ?? 0,
      ]}
      labelDisplayedRows={(info) =>
        `صفحة ${info.page + 1} من ${Math.ceil(info.count / PAGE_SIZE)}`
      }
      component="div"
      count={
        data?.pages ? data?.pages[0].totalDataCount : data.totalDataCount ?? 0
      }
      rowsPerPage={PAGE_SIZE}
      page={page}
      onPageChange={handleChangePage}
      SelectProps={{
        disabled: isDisabled,
      }}
    />
  );
};

export default PaginationButtons;
