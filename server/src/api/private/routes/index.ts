import { Router } from 'express';
import type Routes from '../../../types/Routes';
import login from './Login';
import signup from './Signup';
import verify from './Verify';
import tests from './tests';
import prefs from './prefs'
import details from './details'

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
} as Routes;