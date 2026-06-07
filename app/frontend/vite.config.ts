import { defineConfig } from "vite";

// The API base is read at build/runtime from VITE_API_BASE.
// Defaults to the backend's compose port.
export default defineConfig({
  server: {
    port: 5173,
    host: true,
  },
  preview: {
    port: 5173,
    host: true,
  },
});
