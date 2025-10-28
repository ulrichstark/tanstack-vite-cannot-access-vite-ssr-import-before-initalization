import { createRootRoute } from "@tanstack/react-router";

export const Route = createRootRoute({ shellComponent: ShellComponent });

function ShellComponent() {
    return null;
}
