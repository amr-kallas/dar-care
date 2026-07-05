import { Grid, SxProps, Theme } from "@mui/material";
import { FC, ReactNode } from "react";
type Props = { children: ReactNode; sx?: SxProps<Theme> };
const FilterRow: FC<Props> = ({ children , sx }) => {
  return (
    <Grid container spacing={1} sx={sx}>
      {children}
    </Grid>
  );
};
export default FilterRow;
