import path from 'path';

const filePath = __filename;
const fileExtension = path.extname(filePath);
export default fileExtension === '.ts' ? 'dev' : 'prod';