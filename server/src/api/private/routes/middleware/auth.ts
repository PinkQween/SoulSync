import type { RequestHandler } from "express";
import jwt from 'jsonwebtoken';
import type ExtendedRequest from "../../../../types/extensions/ExtendedRequest";
import resJSONWrapper from "../../../../utils/resJSONWrapper";
import { Errors } from "../../../../types/Errors";

const auth: RequestHandler = (req, res, next) => {
    const extendedReq = req as unknown as ExtendedRequest;
    // Get token from header

    const token = extendedReq.header('Authorization')?.split(' ')[1];
    // const token = req.header('Authorization');

    // Check if token doesn't exist
    if (!token) {
        console.log("No token")
        return res.status(401).json(resJSONWrapper(false, Errors.NO_TOKEN));
    }

    try {
        // Verify token
        
        const decoded = jwt.verify(token, process.env.JWT_SECRET as string);

        // Set user in request object
        extendedReq.user = decoded;

        next();
    } catch (err) {
        console.log("invalid token")
        res.status(401).json(resJSONWrapper(false, Errors.INVALID_TOKEN));
    }
};

export default auth;