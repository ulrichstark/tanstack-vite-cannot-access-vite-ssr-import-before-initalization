import { createServerFn } from "@tanstack/react-start";
import { useEffect } from "react";
import { getCookies } from "@tanstack/react-start/server";
import { House } from "lucide-react";

const reportErrorToServer = createServerFn().handler(() => {
    getCookies();
});

export function ErrorComponent() {
    useEffect(() => {
        reportErrorToServer();
    }, []);

    return <House />;
}
