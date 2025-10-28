import { createRootRoute, HeadContent, Scripts } from "@tanstack/react-router";
import { ReactNode } from "react";

export const Route = createRootRoute({ shellComponent: ShellComponent });

function ShellComponent({ children }: { children: ReactNode }) {
    return (
        <html>
            <head>
                <HeadContent />
            </head>
            <body>
                <main>{children}</main>
                <Scripts />
            </body>
        </html>
    );
}
