import { Router } from 'express';
import findUserByEmail from '../../../utils/findUserByEmail';
import { updateUser } from '../../../utils/saving';
import auth from './middleware/auth';
import type ExtendedRequest from '../../../types/extensions/ExtendedRequest';
import resJSONWrapper from '../../../utils/resJSONWrapper';
import { Errors } from '../../../types/Errors';
import findUserIndex from '../../../utils/findUserIndex';

const route = Router();

route.put('/', auth, async (oldReq, res) => {
    const req = oldReq as unknown as ExtendedRequest;

    const { verificationCode } = req.body;

    console.log(req.user.newUser.email)

    // Find the user by phone number
    const user = findUserByEmail(req.user.newUser.email)

    if (!user) {
        // return res.status(400).json({ error: 'USER_NOT_FOUND' });
        return res.status(400).json(resJSONWrapper(false, Errors.USER_NOT_FOUND));
    }

    console.log(user.code)
    console.log(verificationCode)
    console.log(user.code == verificationCode)

    // Check if the verification code matches
    if (user.code != verificationCode) {
        // return res.status(400).json({ error: 'WRONG_CODE' });
        return res.status(400).json(resJSONWrapper(false, Errors.WRONG_CODE));
    }

    // Update user status or perform any other actions as needed
    user.verified = true;
    user.temp = false;

    // Save user data
    updateUser(user, findUserIndex(user));

    // Respond to the client with success
    // res.json({ success: true });
    res.json(resJSONWrapper(true, {}));
});

export default route;