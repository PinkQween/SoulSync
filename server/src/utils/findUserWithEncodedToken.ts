import getUserData from "./saving";

export default (token: string) => {
    let userData = getUserData();
    
    console.log(token);

    return userData.find((user) => user.token === token);
};