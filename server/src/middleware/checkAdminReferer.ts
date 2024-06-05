import type { RequestHandler } from "express";

const checkAdminReferer: RequestHandler = (req, res, next) => {
    // Check if the request URL matches /api/admin/*
    if (req.url.startsWith('/api/admin/')) {
        // Get the referer or origin header
        const referer = req.get('Referer') || req.get('Origin');

        // Check if referer or origin starts with /admin/
        if (referer && referer.includes('/admin/')) {
            next(); // Allow the request to proceed
        } else {
            res.status(403).send('Forbidden: You do not have access to this resource');
        }
    } else {
        next(); // If not /api/admin/*, proceed as usual
    }
}

export default checkAdminReferer;