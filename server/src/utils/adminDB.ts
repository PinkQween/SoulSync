import path from 'path';
import type AdminCredential from '../types/AdminDB';
import fs from 'fs';

export const saveAdminDataToFile = () => {
    const adminData = getAdminData();
    const filePath = path.join('/Volumes/External (please use)/SoulSync/server/db/admin.json');
    const jsonData = JSON.stringify(adminData, null, 2);

    fs.writeFileSync(filePath, jsonData, 'utf-8');
};

export const addUser = (user: AdminCredential) => {
    const adminData = getAdminData();
    return adminData.push(user);
}

const getAdminData = (): AdminCredential[] => JSON.parse(fs.readFileSync("/Volumes/External (please use)/SoulSync/server/db/admin.json", 'utf-8'));

export default getAdminData;