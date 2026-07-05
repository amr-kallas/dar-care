import Dialog from "@mui/material/Dialog";
import DialogContent from "@mui/material/DialogContent";
import LabelValue from "@components/typography/labelValue";

import { Grid, Stack } from "@mui/material";
import NoData from "@components/feedbacks/noData";
import DialogTitle from "@components/forms/dialogTitle";
import DividedStack, {
  DividedStackProps,
} from "@components/layout/dividedStack";
import useDetailsSearchParams from "@hooks/useDetailsSearchParams";
import { FC } from "react";
import { queries } from "../../apis/user/queries";
import { toisoString } from "@utils/function-helper";
const dividedStackProps: DividedStackProps = {
  gap: 2,
  sx: {
    "& > * ": {
      flexBasis: { xs: "100%" },
      flexGrow: 1,
    },
    "& .label": {
      width: 0.3,
      minWidth: "fit-content",
    },
  },
};
export const Details: FC<{}> = ({}) => {
  const { id, isActive, clearDetailsParams } = useDetailsSearchParams();
  const { data, isLoading, isSuccess, isError } = queries.GetUser(id);
  const handleClose = () => {
    clearDetailsParams();
  };


  const startDate =
    data && data[0] && toisoString(new Date(data[0].startDate)).slice(0, 10);
  const endDate =
    data && data[0] && toisoString(new Date(data[0].endDate)).slice(0, 10);

  const timeDifference =
    new Date(endDate as string).getTime() -
    new Date(startDate as string).getTime();
  const daysDifference = Math.floor(timeDifference / (1000 * 60 * 60 * 24));

  return (
    <Dialog open={isActive} onClose={handleClose} fullWidth maxWidth={"sm"}>
      <DialogTitle onClose={handleClose} fontSize={25} color="primary">
        تفاصيل المستخدم
      </DialogTitle>
      <DialogContent>
        {(isSuccess || isLoading) && (
          <Grid
            container
            mt={0}
            spacing={3}
            justifyContent={"center"}
            alignItems={"start"}
          >
            <Grid item container spacing={2} xs={8}>
              <DividedStack width={1} {...dividedStackProps}>
                <LabelValue
                  isLoading={isLoading}
                  label={"عدد المسحات المتبقية"}
                >
                  {data?.[0]?.remainingScans}
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"تاريخ الاشتراك"}>
                  {data &&
                    data[0] &&
                    toisoString(new Date(data[0].startDate)).slice(0, 10)}
                </LabelValue>
                <LabelValue
                  isLoading={isLoading}
                  label={"تاريخ انتهاء الاشتراك"}
                >
                  {data &&
                    data[0] &&
                    toisoString(new Date(data[0].endDate)).slice(0, 10)}
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"المدة المتبقية"}>
                  {daysDifference}يوم
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"نوع المسحات"}>
                  {data?.[0]?.category == 0 ? "مجاني" : "مدفوع"}
                </LabelValue>
              </DividedStack>
            </Grid>
            <Grid item xs={12} md={4} sx={{ order: { xs: -1, md: 0 } }}>
              <Stack
                sx={{
                  position: "relative",
                  width: { xs: 0.5, md: 1 },
                  mx: "auto",
                }}
              ></Stack>
            </Grid>
          </Grid>
        )}
        {isError && <NoData />}
      </DialogContent>
    </Dialog>
  );
};
