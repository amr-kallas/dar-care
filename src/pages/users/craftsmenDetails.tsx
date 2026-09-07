import type { IAdminProvider } from "@apis/provider/type";
import Dialog from "@mui/material/Dialog";
import DialogContent from "@mui/material/DialogContent";
import LabelValue from "@components/typography/labelValue";
import { Box, Grid, Link, Stack, Typography } from "@mui/material";
import DialogTitle from "@components/forms/dialogTitle";
import DividedStack, {
  DividedStackProps,
} from "@components/layout/dividedStack";
import useDetailsSearchParams from "@hooks/useDetailsSearchParams";
import { FC, useMemo } from "react";
import { storageUrl, toisoString } from "@utils/function-helper";

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

type Props = {
  records: IAdminProvider[];
};

function formatCategories(categories: IAdminProvider["categories"]) {
  if (!categories.length) return "_";
  return categories.map((c) => c.name).join("، ");
}

function statusLabel(status: string) {
  if (status === "available") return "نشط";
  if (status === "unavailable") return "متوقف";
  return status;
}

function verificationLabel(status: IAdminProvider["verification_status"]) {
  if (status === "approved") return "مقبول";
  if (status === "rejected") return "مرفوض";
  if (status === "pending") return "قيد المراجعة";
  return "_";
}

export const CraftsmenDetails: FC<Props> = ({ records }) => {
  const { id, isActive, clearDetailsParams } = useDetailsSearchParams();

  const row = useMemo(
    () => records.find((r) => String(r.id) === id),
    [records, id]
  );

  const identityImage = storageUrl(row?.identity_image);

  const handleClose = () => {
    clearDetailsParams();
  };

  return (
    <Dialog open={isActive} onClose={handleClose} fullWidth maxWidth={"sm"}>
      <DialogTitle onClose={handleClose} fontSize={25} color="primary">
        تفاصيل الحرفي
      </DialogTitle>
      <DialogContent>
        {row ? (
          <Grid
            container
            mt={0}
            spacing={3}
            justifyContent={"center"}
            alignItems={"start"}
          >
            <Grid item container spacing={2} xs={12}>
              <DividedStack width={1} {...dividedStackProps}>
                <LabelValue label={"الاسم"}>{row.name}</LabelValue>
                <LabelValue label={"رقم الموبايل"}>{row.phone}</LabelValue>
                <LabelValue label={"البريد الإلكتروني"}>{row.email}</LabelValue>
                <LabelValue label={"التخصص"}>
                  {formatCategories(row.categories)}
                </LabelValue>
                <LabelValue label={"سنوات الخبرة"}>
                  {row.years_of_experience}
                </LabelValue>
                <LabelValue label={"نبذة"}>{row.bio || "_"}</LabelValue>
                <LabelValue label={"التقييم"}>{row.rating_avg}</LabelValue>
                <LabelValue label={"تاريخ الانضمام"}>
                  {row.created_at
                    ? toisoString(new Date(row.created_at)).slice(0, 10)
                    : "_"}
                </LabelValue>
                <LabelValue label={"الحالة"}>
                  {statusLabel(row.status)}
                </LabelValue>
                <LabelValue label={"حالة التوثيق"}>
                  {verificationLabel(row.verification_status)}
                </LabelValue>
                {row.verification_status === "rejected" && (
                  <LabelValue label={"سبب الرفض"}>
                    {row.rejection_reason || "_"}
                  </LabelValue>
                )}
              </DividedStack>
            </Grid>
            <Grid item xs={12}>
              <Typography color="primary" fontWeight={600} mb={1}>
                صورة الهوية
              </Typography>
              {identityImage ? (
                // Opens the original file in a new tab so the admin can zoom in
                // on details the thumbnail is too small to show.
                <Link href={identityImage} target="_blank" rel="noopener">
                  <Box
                    component="img"
                    src={identityImage}
                    alt="صورة هوية الحرفي"
                    sx={{
                      width: "100%",
                      maxHeight: 320,
                      objectFit: "contain",
                      borderRadius: 1,
                      border: "1px solid",
                      borderColor: "grey.300",
                      bgcolor: "grey.50",
                    }}
                  />
                </Link>
              ) : (
                <Typography color="text.secondary">
                  لم يرفع الحرفي صورة هوية.
                </Typography>
              )}
            </Grid>
          </Grid>
        ) : (
          <Stack py={2}>لا توجد بيانات لهذا الحرفي.</Stack>
        )}
      </DialogContent>
    </Dialog>
  );
};
