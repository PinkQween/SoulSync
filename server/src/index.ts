import * as net from "net";
import express from "express";
import api from './api';
import path from 'path';
import { env } from './utils';
import bodyParser from 'body-parser';
import requireAdmin from "./middleware/requireAdmin";
import checkAdminReferer from "./middleware/checkAdminReferer";
import {} from './utils/saving';
import { execSync } from "child_process";

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
const adminDir = path.join(__dirname, env === 'dev' ? '..' : '../..', 'admin');


app.use('/api/admin/*', checkAdminReferer);
app.use('/admin/*', requireAdmin);

app.use(bodyParser.json());
app.use("/api", api);

app.use('/admin', express.static(adminDir));
app.get('/admin/*', (req, res) => {
    res.sendFile(path.join(adminDir, 'index.html'));
});

app.use(express.static(publicDir));
app.get('*', (req, res) => {
    res.sendFile(path.join(publicDir, 'index.html'));
});



// const httpsServer = https.createServer({ key: key, cert: cert }, app);

function killProcessOnPort(port: number) {
    try {
        // Use lsof to find the process ID (PID) using the specified port
        const pid = execSync(`lsof -ti tcp:${port}`);

        // Use kill command to terminate the process
        execSync(`kill -9 ${pid}`);

        console.log(`Successfully killed process on port ${port}.`);
    } catch (error: any) {
        console.error(`Error killing process on port ${port}: ${error.stderr ? error.stderr.toString() : error.toString()}`);
    }
}


killProcessOnPort(PORT);

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});