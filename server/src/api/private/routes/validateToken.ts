import { Router } from 'express';
import auth from './middleware/auth';
import resJSONWrapper from '../../../utils/resJSONWrapper';

const route = Router();

route.post('/', auth, async (req, res) => {
    res.json(resJSONWrapper(true, {}));
});

export default route;