import { createServerFn } from "@tanstack/react-start";
import { useEffect } from "react";
import { createSupabaseClient } from "./createSupabaseClient";

const reportErrorToServer = createServerFn().handler(() => {
    createSupabaseClient();
});

export function ErrorComponent() {
    useEffect(() => {
        reportErrorToServer();
    }, []);

    return null;
}
