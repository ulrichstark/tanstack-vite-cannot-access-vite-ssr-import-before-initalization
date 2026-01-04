import { createRootRoute } from "@tanstack/react-router";
import { ReactNode } from "react";

export const Route = createRootRoute({ shellComponent: ShellComponent });

function ShellComponent({ children }: { children: ReactNode }) {
    return children;
}
