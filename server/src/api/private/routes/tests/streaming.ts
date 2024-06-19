import { Router } from 'express';
import auth from '../middleware/auth';
import fs from 'fs';

const route = Router();

route.get('/', auth, async (req, res) => {
    const videoPath = '/Users/skairipa/Documents/st23_kimi-no-na-wa-dub-episode-dub.mp4';
    const stat = fs.statSync(videoPath);
    const fileSize = stat.size;
    const range = req.headers.range;

    if (range) {
        const parts = range.replace(/bytes=/, "").split("-");
        const start = parseInt(parts[0], 10);
        const end = parts[1] ? parseInt(parts[1], 10) : fileSize - 1;
        const chunksize = (end - start) + 1;
        const file = fs.createReadStream(videoPath, { start, end });
        const head = {
            'Content-Range': `bytes ${start}-${end}/${fileSize}`,
            'Accept-Ranges': 'bytes',
            'Content-Length': chunksize,
            'Content-Type': 'video/mp4',
            'user': 'hanna@hannaskairipa.com'
        };

        res.writeHead(206, head);
        file.pipe(res);
    } else {
        const head = {
            'Content-Length': fileSize,
            'Content-Type': 'video/mp4',
            'user': 'hanna@hannaskairipa.com'
        };
        res.writeHead(200, head);
        fs.createReadStream(videoPath).pipe(res);
    }
});

route.get('/9:16', auth, async (req, res) => {
    const videos = [
        "/Volumes/External (please use)/SoulSync/client/iOS/SoulSync/TestingData/video1.mp4",
        "/Volumes/External (please use)/SoulSync/client/iOS/SoulSync/TestingData/video2.mp4"
    ];
    const videoPath = videos[Math.floor(Math.random() * videos.length)];

    const stat = fs.statSync(videoPath);
    const fileSize = stat.size;
    const range = req.headers.range;

    if (range) {
        const parts = range.replace(/bytes=/, "").split("-");
        const start = parseInt(parts[0], 10);
        const end = parts[1] ? parseInt(parts[1], 10) : fileSize - 1;
        const chunksize = (end - start) + 1;
        const file = fs.createReadStream(videoPath, { start, end });
        const head = {
            'Content-Range': `bytes ${start}-${end}/${fileSize}`,
            'Accept-Ranges': 'bytes',
            'Content-Length': chunksize,
            'Content-Type': 'video/mp4',
            'user': 'hanna@hannaskairipa.com'
        };

        res.writeHead(206, head);
        file.pipe(res);
    } else {
        const head = {
            'Content-Length': fileSize,
            'Content-Type': 'video/mp4',
            'user': 'hanna@hannaskairipa.com'
        };
        res.writeHead(200, head);
        fs.createReadStream(videoPath).pipe(res);
    }
});

export default route; 