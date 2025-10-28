import { nitroV2Plugin } from "@tanstack/nitro-v2-vite-plugin";
import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import react from "@vitejs/plugin-react";
import { defineConfig } from "vite";

export default defineConfig(({}) => {
    return {
        plugins: [tanstackStart(), nitroV2Plugin(), react()],
        server: { port: 3000, open: true, host: true },
    };
});
