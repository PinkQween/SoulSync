import type UserData from "../types/UserData";
import getUserData from "./saving";

export default (user: UserData) => {
    let userData = getUserData();

    return userData.findIndex(i => i.email === user.email);
}