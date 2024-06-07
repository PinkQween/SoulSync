import { Router } from 'express';
import bcrypt from 'bcrypt';
import getUserData, { addUser } from '../../../utils/saving';
import type UserData from '../../../types/UserData';
import jwt from 'jsonwebtoken';
// import sendText from '../../../utils/sendText';
import sendEmail from '../../../utils/sendEmail';
import verifyEmail from '../../../templates/verifyEmail';
import resJSONWrapper from '../../../utils/resJSONWrapper';
import { Errors } from '../../../types/Errors';

const route = Router();
route.post('/', async (req, res) => {
    const { username, email, password, confirmPassword, birthdate, deviceID } = req.body;

    // console.log(email);

    if (getUserData().some(user => user.email === email)) {
        // return res.status(400).json({ error: 'email_exists' });
        return res.status(400).json(resJSONWrapper(false, Errors.EMAIL_EXISTS));
    }

    // Validate password match
    if (password !== confirmPassword) {
        console.log('Passwords do not match')
        // return res.status(400).json({ error: 'Passwords do not match' });
        return res.status(400).json(resJSONWrapper(false, Errors.PASSWORD_MISMATCH));
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    const code = Math.floor(100000 + Math.random() * 900000);

    // Save user data (for demonstration purposes only)
    const newUser: UserData = {
        username,
        birthdate,
        email: (email as string).toLowerCase(),
        hashedPassword,
        code,
        deviceID: [deviceID],
        verified: false,
        temp: false,
        createdAt: new Date().getTime()
    };

    newUser.token = jwt.sign({ newUser }, process.env.JWT_SECRET as string);

    addUser(newUser);

    ///// TODO: send text to verify phone number
    // ! If anyone knows to send sms please let me know, for know replacing with email

    sendEmail({
        to: newUser.email,
        subject: 'Verify your email',
        body: verifyEmail({ code })
    })

    // res.json({ success: true, token: newUser.token });
    res.json(resJSONWrapper(true, {
        token: newUser.token
    }));
});

export default route; 