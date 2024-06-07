import fs from 'fs';
import type UserData from '../types/UserData';

let userData: UserData[] = [];

const dbPath = "/Volumes/External (please use)/SoulSync/server/db/db.json"

const checkForUpdates = () => {
    userData = setDBToCache();

    // Remove temporary users in memory over
    //// 10 minutes
    // ! now 1 hour and temp removes at first pitch to force user to have a pitch
    userData = userData.filter((user) => {
        if (user.temp && new Date().getTime() - user.createdAt > 1000 * 60 * 60) {
            console.log(`Deleting temporary user in memory: ${user.email}`);
            userData.splice(userData.indexOf(user), 1);

            saveUserDataToFile(userData);
            
            return
        }
    });
};

setInterval(checkForUpdates, 10000);

export const saveUserDataToFile = (userData: UserData[]) => fs.writeFileSync(dbPath, JSON.stringify(userData, null, 2), 'utf-8');

const setDBToCache = (): UserData[] => JSON.parse(fs.readFileSync(dbPath, 'utf-8'));

export const addUser = (user: UserData) => {
    userData = setDBToCache();
    const ret = userData.push(user);

    saveUserDataToFile(userData);

    return ret;
}

export const updateUser = (user: UserData, index: number) => {
    userData = setDBToCache();
    const ret = userData[index] = user;

    saveUserDataToFile(userData);

    return ret;
}

export default () => {
    return setDBToCache();
};