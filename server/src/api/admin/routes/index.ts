import { Router } from 'express';
import type Routes from '../../../types/Routes';
import sendPush from './sendPush';

const route = Router();

route.get('/', (_, res) => {
    res.status(200).json({ message: 'API up and running!!!' });
});

export default {
    '/': route,
    '/send-push': sendPush
} as Routes;