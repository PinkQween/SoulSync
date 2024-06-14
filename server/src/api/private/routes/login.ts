import { Router } from 'express';
import findUserByEmail from '../../../utils/findUserByEmail';
import bcrypt from 'bcrypt';
import { updateUser } from '../../../utils/saving';
import resJSONWrapper from '../../../utils/resJSONWrapper';
import { Errors } from '../../../types/Errors';
import findUserIndex from '../../../utils/findUserIndex';

const route = Router();

route.post('/', async (req, res) => {
    const { email, password, deviceID } = req.body;

    const user = findUserByEmail(email)

    if (!user) {
        // return res.status(400).json({ error: 'user_not_found' });
        return res.status(400).json(resJSONWrapper(false, Errors.USER_NOT_FOUND));
    }

    if (await bcrypt.compare(password, user.hashedPassword ?? "")) {
        // res.json({ success: true, token: user.token });
        res.json(resJSONWrapper(true, {
            token: user.token
        }));
    } else {
        // return res.status(400).json({ error: 'wrong_password' });
        return res.status(400).json(resJSONWrapper(false, Errors.WRONG_PASSWORD));
    }

    if (!user.deviceID.includes(deviceID)) {
        // Add the new device ID to the array
        user.deviceID.push(deviceID);
        // Save user data
        updateUser(user, findUserIndex(user));
    }
});

export default route; 