import { Router } from 'express';
import type Routes from '../../../types/Routes';
import login from './login';
import signup from './signup';
import verify from './verify';
import tests from './tests';
import prefs from './prefs'
import details from './details'
import uploadPitch from './uploadPitch'

const route = Router();

route.get('/', (_, res) => {
    res.status(200).json({ message: 'API up and running!!!' });
});

export default {
    '/': route,
    '/login': login,
    '/signup': signup,
    '/verify': verify,
    '/tests': tests,
    '/prefs': prefs,
    '/details': details,
    '/upload-pitch': uploadPitch
} as Routes;