import { Router } from 'express';
import type Routes from '../../../../types/Routes';
import streaming from './streaming';

const route = Router();

route.get('/', (_, res) => {
    res.status(200).json({ message: 'API up and running!!!' });
});

const testRoutes = {
    '/': route,
    '/streaming': streaming
} as Routes;

const allRoutes = Router();

for (const route of Object.keys(testRoutes)) {
    allRoutes.use(route, testRoutes[route]);
}

export default allRoutes;