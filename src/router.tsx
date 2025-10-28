import { createRouter } from "@tanstack/react-router";
import { ErrorComponent } from "./ErrorComponent";
import { NotFoundComponent } from "./NotFoundComponent";
import { routeTree } from "./routeTree.gen";

export function getRouter() {
    const router = createRouter({
        routeTree,
        defaultErrorComponent: ErrorComponent,
        defaultNotFoundComponent: NotFoundComponent,
    });

    return router;
}
