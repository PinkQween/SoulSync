import { Router } from 'express';
import routes from './routes';

const api = Router();

// Iterate over the keys of the routes object
for (const route of Object.keys(routes)) {
    api.use(route, routes[route]);
}

export default api;
