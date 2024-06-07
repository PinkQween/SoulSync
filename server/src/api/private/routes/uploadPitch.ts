import { Router } from 'express';
import auth from './middleware/auth';
import findUserWithEncodedToken from '../../../utils/findUserWithEncodedToken';
import { updateUser } from '../../../utils/saving';
import findUserIndex from '../../../utils/findUserIndex';
import type UserData from '../../../types/UserData';
import resJSONWrapper from '../../../utils/resJSONWrapper';
import multer from 'multer';

const route = Router();

const storage = multer.diskStorage({
    destination: '/Volumes/External (please use)/SoulSync/server/pitches',
    filename: (req, file, cb) => {
        // Get user email from request header
        const user = findUserWithEncodedToken(req.header('Authorization')?.split(' ')[1] ?? "") as UserData;

        // Construct filename with user email + .mp4 extension
        const filename = `${user.email}.mp4`;
        cb(null, filename);
    }
});

const upload = multer({ storage: storage });

route.post('/', auth, upload.single('video'), async (oldReq, res) => {
    const req = oldReq as any;

    // Get bio data from request header
    const { bio } = req.body;

    const user = findUserWithEncodedToken(req.header('Authorization')?.split(' ')[1] ?? "") as UserData;

        user.bio = bio ?? "";

        if (!user.bio) user.bio = "";
        if (user.temp) user.temp = true;

        updateUser(user, findUserIndex(user as UserData));

        res.json(resJSONWrapper(true, {}));
});

export default route;
