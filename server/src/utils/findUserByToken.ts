import type UserData from "../types/UserData";
import getUserData from "./saving";

export default (decodedToken: UserData) => {
    let userData = getUserData();

    return userData.find((user) => user.token === decodedToken.token);
};