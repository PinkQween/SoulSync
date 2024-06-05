import { Router } from 'express';
import routes from './routes';
import privateRoutes from './private';
import adminRoutes from './admin';

const api = Router();

// Iterate over the keys of the routes object
for (const privateRoute of Object.keys(privateRoutes)) {
    api.use(`/private${privateRoute}`, privateRoutes[privateRoute]);
}

for (const adminRoute of Object.keys(adminRoutes)) {
    api.use(`/admin${adminRoute}`, adminRoutes[adminRoute]);
}

for (const route of Object.keys(routes)) {
    api.use(route, routes[route]);
}

export default api;
