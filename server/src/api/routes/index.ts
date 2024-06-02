import { Router } from 'express';
import type Routes from '../../types/Routes';

const route = Router();

route.get('/', (req, res) => {
    res.send('Hello World!');
});

export default {
    '/': route,
} as Routes;