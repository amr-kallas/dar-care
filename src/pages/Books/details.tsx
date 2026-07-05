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
// import { queries } from "../../apis/user/queries";
import { toisoString } from "@utils/function-helper";
import queries from "@apis/QuesGenerator/query";
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
  const { data, isLoading, isSuccess, isError } = queries.GetBook(id);
  const handleClose = () => {
    clearDetailsParams();
  };




  return (
    <Dialog open={isActive} onClose={handleClose} fullWidth maxWidth={"sm"}>
      <DialogTitle onClose={handleClose} fontSize={25} color="primary">
        تفاصيل الكتاب
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
                <LabelValue isLoading={isLoading} label={"العنوان"}>
                  {data?.title}
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"الصف"}>
                  {data?.className}
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"البلد"}>
                  {data?.country}
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"اللغة"}>
                  {data && data.language == "0" ? "العربية" : 'الانجليزية'}
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"اسئلة التوصيل"}>
                  {data?.matchCount}
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"اسئلة الاختيار من متعدد"}>
                  {data?.multiChoiceCount}
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"اسئلة الصح والخطأ"}>
                  {data?.trueFalseCount}
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"الاسئلة الكتابية"}>
                  {data?.writeCount}
                </LabelValue>
                <LabelValue isLoading={isLoading} label={"عدد الصفحات"}>
                  {data?.pageCount}
                </LabelValue>

                <LabelValue isLoading={isLoading} label={"تاريخ الانشاء"}>
                  {data && toisoString(new Date(data.createdAt)).slice(0, 10)}
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
