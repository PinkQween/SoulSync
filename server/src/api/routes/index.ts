import { Router } from 'express';
import type Routes from '../../types/Routes';

const route = Router();

route.get('/', (_, res) => {
    res.status(200).json({ message: 'API up and running!!!' });
});

export default {
    '/': route,
} as Routes;