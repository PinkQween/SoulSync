import type { Request } from "express";
import adminData from "./adminDB";
import type AdminCredential from "../types/AdminDB";

export default async (req: Request) => {
    const authHeader = (req.headers["authorization"] || req.headers["Authorization"]) as string;

    if (authHeader == null) return false;

    const [tempUsername, password] = Buffer.from(authHeader.split(" ")[1], "base64").toString().split(":");

    const { username, hash } = adminData.find((user) => user.username === tempUsername) as AdminCredential

    return username && (await isValidPassword(password, hash));
}

export const isValidPassword = async (password: string, hashedPassword: string) => {
    return await hashPassword(password) === hashedPassword;
}

const hashPassword = async (password: string) => {
    const arrayBuffer = await crypto.subtle.digest("SHA-512", new TextEncoder().encode(password));
    return Buffer.from(arrayBuffer).toString("base64");
}