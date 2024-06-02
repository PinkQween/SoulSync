import * as net from "net";
import express from "express";
import apn from "apn";
import fs from 'fs';
import https from 'https';
import api from './api';
import path from 'path';
import { env } from './utils';
import bodyParser from 'body-parser';

const findNextAvailablePort = (port: number) => {
    return new Promise<number>((resolve, reject) => {
        const portTester = net.createServer();
        portTester.once("error", (err) => {
            if ((err as NodeJS.ErrnoException).code === "EADDRINUSE") {
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

const PORT = await findNextAvailablePort(process.env.PORT as unknown as number || 443);
const app = express();
// const key = fs.readFileSync('certs/server.key');
// const cert = fs.readFileSync('certs/server.crt');
const publicDir = path.join(__dirname, env === 'dev' ? '..' : '../..', 'public');

const apnProvider = new apn.Provider({
    token: {
        key: fs.readFileSync('certs/APNS.p8'),
        keyId: process.env.APPLE_APNS_KEY_ID as string,
        teamId: process.env.APPLE_TEAM_ID as string,
    },
    production: false
});



app.use(express.static(publicDir));

app.get('*', (req, res) => {
    res.sendFile(path.join(publicDir, 'index.html'));
});



app.use(bodyParser.json());
app.use("/api", api);



// const httpsServer = https.createServer({ key: key, cert: cert }, app);

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});