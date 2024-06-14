import type { Response, NextFunction } from "express"

export default (req: any, res: Response, next: NextFunction) => {
    const host = req.get('Host');
    if (host === 'admin.soulsync.hannaskairipa.com') {
        req.context = { isAdmin: true };
    } else if (host === 'soulsync.hannaskairipa.com') {
        req.context = { isAdmin: false };
    } else {
        req.context = { isAdmin: false }; // Default to public if host is unrecognized
    }
    next();
};