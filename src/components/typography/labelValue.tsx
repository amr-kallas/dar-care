import { Stack, StackProps } from "@mui/material";
import { Box } from "@mui/system";
import Skeleton, { SkeletonProps } from "@components/feedbacks/skeleton";
import { FC, ReactNode } from "react";
export type KeyValueProps = {
  label: ReactNode;
  children: ReactNode;
  noColon?: boolean;
  ltr?: boolean;
  skeletonProps?: SkeletonProps;
  isLoading?: boolean;
} & StackProps;
const LabelValue: FC<KeyValueProps> = ({
  children,
  label,
  isLoading,
  skeletonProps,
  noColon = false,
  ltr = false,
  ...props
}) => {
  return (
    <Stack
      direction={"row"}
      gap={1}
      {...props}
      sx={{
        fontSize: 14,
        wordBreak: "break-word",
        ...props.sx,
      }}
      className="label-value"
    >
      <Stack
        className="label"
        color="secondary.800"
        sx={{ wordBreak: "normal" }}
        direction="row"
      >
        {label}
        {!noColon && ":"}
      </Stack>

      <Box color="text.primary" className="value">
        {!isLoading && (children ?? <Empty />)}
      </Box>
      {isLoading && (
        <Skeleton
          widthRange={{ min: 40, max: 70 }}
          sx={{ my: "auto" }}
          height={"100%"}
          {...skeletonProps}
        />
      )}
    </Stack>
  );
};
const Empty = () => (
  <Box px={3} fontWeight="bold">
    -
  </Box>
);
export default LabelValue;
