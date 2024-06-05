import { Router } from 'express';
import auth from './middleware/auth';
import { saveUserDataToFile, updateUser } from '../../../utils/saving';
import findUserByEmail from '../../../utils/findUserByEmail';
import type ExtendedRequest from '../../../types/extensions/ExtendedRequest';
import resJSONWrapper from '../../../utils/resJSONWrapper';
import { Errors } from '../../../types/Errors';
import findUserIndex from '../../../utils/findUserIndex';

const route = Router();

route.post('/', auth, (oldReq, res) => {
    console.log('Updating user details...');

    const req = oldReq as unknown as ExtendedRequest;

    const { gender, sex, sexuality, relationshipStatus, ageRange } = req.body;

    // Find the user by phone number
    const user = findUserByEmail(req.user.newUser.email)

    if (!user) {
        return res.status(400).json(resJSONWrapper(false, Errors.USER_NOT_FOUND));
    }

    // Update the user's preferences
    user.preferences = {
        gender,
        sex,
        sexuality,
        relationshipStatus,
        ageRange,
    };

    updateUser(user, findUserIndex(user));

    // Respond to the client with success
    res.json(resJSONWrapper(true, {}));
})

export default route;