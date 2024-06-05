import type { Request } from "express";
// import jwt from 'jsonwebtoken';

export default interface ExtendedRequest extends Request {
    user: any;
}