import NoData from "@components/feedbacks/noData";
import DialogTitle from "@components/forms/dialogTitle";
import DividedStack, {
  DividedStackProps,
} from "@components/layout/dividedStack";
import LabelValue from "@components/typography/labelValue";
import useDetailsSearchParams from "@hooks/useDetailsSearchParams";
import { Grid, Stack } from "@mui/material";
import Dialog from "@mui/material/Dialog";
import DialogContent from "@mui/material/DialogContent";
import { FC } from "react";
// import { queries } from "../../apis/user/queries";
import queries from "@apis/QuesGenerator/query";
import { questionDifficulty, questionTypes } from "./Ques";
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
  const { data, isLoading, isSuccess, isError } = queries.GetQues(id);
  const handleClose = () => {
    clearDetailsParams();
  };




  return (
    <Dialog open={isActive} onClose={handleClose} fullWidth maxWidth={"sm"}>
      <DialogTitle onClose={handleClose} fontSize={25} color="primary">
        تفاصيل السؤال
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
                <LabelValue isLoading={isLoading} label="الصعوبة">
                  {questionDifficulty?.[Number(data?.difficulty)] ?? "غير محدد"}
                </LabelValue>
                <LabelValue isLoading={isLoading} label="النوع">
                  {questionTypes?.[Number(data?.type)] ?? "غير محدد"}
                </LabelValue>
                {data?.isCorrect != null && (
                  <LabelValue isLoading={isLoading} label="الاجابة">
                    {data?.isCorrect ? "صحيحة" : "خاطئة"}
                  </LabelValue>
                )}
                {data?.matchAnswers  &&
                  data?.matchAnswers.map((match) => (
                    <div>
                      <LabelValue isLoading={isLoading} label="السؤال">
                        {match.firstHalf}
                      </LabelValue>
                      <LabelValue isLoading={isLoading} label="الاجابة">
                        {match.secondHalf}
                      </LabelValue>
                    </div>
                  ))}
                {data?.multiChoiceAnswers  &&
                  data?.multiChoiceAnswers.map((choice, index) => (
                    <div className="felx justify-content-center align-items-center">
                      <LabelValue
                        isLoading={isLoading}
                        label={` الاجابة ${index + 1}`}
                      >
                        {choice.title}
                        {choice.isCorrect && <>✔️</>}
                      </LabelValue>
                    </div>
                  ))}
               
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
