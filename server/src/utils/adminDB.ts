import path from 'path';
import type AdminCredential from '../types/AdminDB';
import env from './env';
import fs from 'fs';

let adminData: AdminCredential[] = [];

const checkForUpdates = () => {
    try {
        const fileData = fs.readFileSync('/Volumes/External (please use)/SoulSync/server/db/admin.json', 'utf-8');
        adminData = JSON.parse(fileData);
    } catch (error) {
        console.error('Error reading initial user data file:', error);
    }
};

setInterval(checkForUpdates, 2500);

export const saveAdminDataToFile = () => {
    console.log('Saving user data to file...');
    console.log(adminData);
    const filePath = path.join('/Volumes/External (please use)/SoulSync/server/db/admin.json');
    const jsonData = JSON.stringify(adminData, null, 2);

    fs.writeFileSync(filePath, jsonData, 'utf-8');
};

try {
    const fileData = fs.readFileSync('/Volumes/External (please use)/SoulSync/server/db/admin.json', 'utf-8');
    adminData = JSON.parse(fileData);
    console.log(adminData)
} catch (error) {
    console.error('Error reading initial user data file:', error);
}

export const addUser = (user: AdminCredential) => {
    return adminData.push(user);
}

export default adminData;

process.on('exit', () => {
    console.log('Exiting... Saving user data to file.');
    saveAdminDataToFile();
});