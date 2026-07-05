import { createContext, useState, useContext, FC } from "react";
type sideBarContextType = {
  isOpen: boolean;
  setIsOpen: React.Dispatch<React.SetStateAction<boolean>>;
};
const SideBarContext = createContext<sideBarContextType>(
  {} as sideBarContextType
);

export const SideBarProvider = ({ children }: { children: React.ReactNode }) => {
  const [isOpen, setIsOpen] = useState(true);

  return (
    <SideBarContext.Provider value={{ isOpen, setIsOpen }}>
      {children}
    </SideBarContext.Provider>
  );
};


export const useSideBar = () => useContext(SideBarContext);
