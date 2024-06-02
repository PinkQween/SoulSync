import fs from 'fs';
import path from 'path';
import type UserData from '../types/UserData';

let userData: UserData[] = [];

const checkForUpdates = () => {
    // console.log("Checking for updates...");
    try {
        const fileData = fs.readFileSync(path.join(__dirname, '../../db/other/soulSyncUsers.json'), 'utf-8');
        userData = JSON.parse(fileData);
    } catch (error) {
        console.error('Error reading initial user data file:', error);
    }

    const currentTime = new Date().getTime();

    // Remove temporary users in memory
    userData = userData.filter((user) => {
        if (user.temp && currentTime - user.createdAt > 10 * 60 * 1000) {
            console.log(`Deleting temporary user in memory: ${user.phoneNumber}`);
            return false;
        }
        return true;
    });

    // Remove temporary users from the JSON file
    saveUserDataToFile();
};

setInterval(checkForUpdates, 2500);

// Schedule a function to delete temporary users after 10 minutes
setTimeout(() => {
    console.log("Deleting temporary users older than 10 minutes...");

    // Remove temporary users in memory
    userData = userData.filter(
        (user) => !user.temp || new Date().getTime() - user.createdAt <= 10 * 60 * 1000
    );

    // Remove temporary users from the JSON file
    saveUserDataToFile();
}, 10 * 60 * 1000);

const saveUserDataToFile = () => {
    const filePath = path.join(__dirname, '../../db/db.json');
    const jsonData = JSON.stringify(userData, null, 2);

    fs.writeFileSync(filePath, jsonData, 'utf-8');
};

export default userData;