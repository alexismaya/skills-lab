import overlay from "@replit/vite-plugin-runtime-error-modal";
const replId = process.env.REPL_ID;
export default { plugins: replId ? [overlay()] : [] };
