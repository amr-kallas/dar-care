import { Divider, Stack, StackProps } from "@mui/material";
import { FC, ReactNode } from "react";
export type DividedStackProps = StackProps & { children?: ReactNode[] };
const DividedStack: FC<DividedStackProps> = ({ children, ...props }) => {
return (
  <Stack {...props}>
    {children?.filter(Boolean).map((child, index, array) => (
      <Stack key={index} gap={props.gap} justifyContent="space-between">
        {child}
        {index < array.length - 1 && <Divider />}
      </Stack>
    ))}
  </Stack>
);
};
export default DividedStack;
