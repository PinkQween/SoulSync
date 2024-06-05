import type { RequestHandler } from "express";
import isAdminAuthenticated from "../utils/isAdminAuthenticated";

const requireAdmin: RequestHandler = async (req, res, next) => {
    if (await isAdminAuthenticated(req) === false) {
        res.status(401).set('WWW-Authenticate', 'Basic').send('Unauthorized');
    } else {
        next();
    }
}

export default requireAdmin;