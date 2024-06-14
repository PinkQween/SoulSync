import * as net from "net";
import express from "express";
import api from './api';
import path from 'path';
import { env } from './utils';
import bodyParser from 'body-parser';
import requireAdmin from "./middleware/requireAdmin";
import checkAdminReferer from "./middleware/checkAdminReferer";
import proxy from 'express-http-proxy'
import http from 'http';
import EventEmitter from "events";
import setContextByHost from "./middleware/setContextByHost";

EventEmitter.defaultMaxListeners = 200;

const findNextAvailablePort = (port: number) => {
    return new Promise((resolve, reject) => {
        const portTester = net.createServer();
        portTester.once("error", (err: any) => {
            if (err.code === "EADDRINUSE") {
                resolve(findNextAvailablePort(port + 1));
            } else {
                reject(err);
            }
        });
        portTester.once("listening", () => {
            portTester.once("close", () => {
                resolve(port);
            }).close();
        });
        portTester.listen(port);
    });
}

(async () => {
    const PORT = await findNextAvailablePort(parseInt(process.env.PORT || "443") || 443);
    const app = express();
    const publicDir = path.join(__dirname, env === 'dev' ? '..' : '../..', 'public');
    const adminDir = path.join(__dirname, env === 'dev' ? '..' : '../..', 'admin');
    const adminRouter = express.Router();
    const publicRouter = express.Router();

    app.disable('x-powered-by');

    adminRouter.use(bodyParser.json());
    adminRouter.use('/api/*', checkAdminReferer);
    adminRouter.use("/api", api);
    adminRouter.use('/', express.static(adminDir));
    adminRouter.get('*', (req, res) => res.sendFile(path.join(adminDir, 'index.html')));
    adminRouter.use('/dev/*', proxy("http://localhost:5173/"));

    publicRouter.use(bodyParser.json());
    publicRouter.use("/api", api);
    publicRouter.use(express.static(publicDir));
    publicRouter.get('*', (req, res) => {
        res.sendFile(path.join(publicDir, 'index.html'));
    });

    app.use(setContextByHost);

    app.use((req: any, res, next) => {
        if (req.context && req.context.isAdmin) {
            adminRouter(req, res, next);
        } else {
            publicRouter(req, res, next);
        }
    });

    const server = http.createServer(app);

    server.on('connection', (conn) => {
        conn.setMaxListeners(200); // Set to an appropriate number
    });

    server.listen(PORT, () => {
        console.log(`Server listening on port ${PORT}`);
    });
})();
