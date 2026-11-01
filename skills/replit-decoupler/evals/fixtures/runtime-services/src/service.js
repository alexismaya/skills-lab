import { Client } from "@replit/object-storage";
const dbUrl = process.env.REPLIT_DB_URL;
export const client = new Client({ dbUrl });
