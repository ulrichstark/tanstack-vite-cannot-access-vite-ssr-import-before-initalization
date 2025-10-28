import { createRouter } from "@tanstack/react-router";
import { ErrorComponent } from "./ErrorComponent";
import { routeTree } from "./routeTree.gen";

export function getRouter() {
    return createRouter({
        routeTree,
        defaultErrorComponent: ErrorComponent,
    });
}
