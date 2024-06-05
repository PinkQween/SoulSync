import express from 'express';
import apn from 'apn';
import fs from 'fs';
import path from 'path';
import { env } from '../../../utils';

const route = express.Router();

route.post('/', (req, res) => {
    const { message, deviceToken, environmentValue } = req.body;

    const apnProvider = new apn.Provider({
        token: {
            key: fs.readFileSync('/Volumes/External (please use)/SoulSync/server/certs/apple.p8'),
            keyId: process.env.APPLE_APNS_KEY_ID as string,
            teamId: process.env.APPLE_TEAM_ID as string,
        },
        production: environmentValue == "dev"
    });

    const notification = new apn.Notification();

    notification.alert = message;
    notification.topic = "com.hannaskairipa.SoulSync";

    apnProvider.send(notification, deviceToken);

    res.status(200).json({ message: 'Push sent' });
});

export default route;