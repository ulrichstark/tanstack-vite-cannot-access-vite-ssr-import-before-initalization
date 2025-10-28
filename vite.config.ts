import { nitroV2Plugin } from "@tanstack/nitro-v2-vite-plugin";
import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import react from "@vitejs/plugin-react";

export default {
    plugins: [tanstackStart(), nitroV2Plugin(), react()],
    server: { open: true },
};
