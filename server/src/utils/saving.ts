import fs from 'fs';
import type UserData from '../types/UserData';

let userData: UserData[] = [];

const dbPath = "/Volumes/External (please use)/SoulSync/server/db/db.json"

const checkForUpdates = () => {
    userData = setDBToCache();

    // Remove temporary users in memory
    userData = userData.filter((user) => {
        if (user.temp && new Date().getTime() - user.createdAt > 1000 * 60 * 10) {
            console.log(`Deleting temporary user in memory: ${user.email}`);
            userData.splice(userData.indexOf(user), 1);

            saveUserDataToFile();
            
            return
        }
    });
};

setInterval(checkForUpdates, 10000);

export const saveUserDataToFile = () => fs.writeFileSync(dbPath, JSON.stringify(userData, null, 2), 'utf-8');

const setDBToCache = (): UserData[] => JSON.parse(fs.readFileSync(dbPath, 'utf-8'));

export const addUser = (user: UserData) => {
    const ret = userData.push(user);

    saveUserDataToFile();

    return ret;
}

export const updateUser = (user: UserData, index: number) => {
    const ret = userData[index] = user;

    saveUserDataToFile();

    return ret;
}

export default () => {
    return setDBToCache();
};

userData = setDBToCache()

process.on('SIGINT', () => {
    console.log('Exiting... Saving user data to file.');
    saveUserDataToFile();
    console.log(userData);
});

// console.log(JSON.parse(fs.readFileSync(dbPath, 'utf-8')));