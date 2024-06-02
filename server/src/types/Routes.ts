import type { Router } from "express";

export default interface Routes {
    [key: string]: Router;
}