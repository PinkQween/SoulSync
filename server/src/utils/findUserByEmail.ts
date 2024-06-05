import getUserData from "./saving";

export default (email: string) => {
    let userData = getUserData();

    console.log(email)
    userData.map(user => {
        console.log(user.email)
    });

    console.log(userData);

    return userData.find((user) => user.email.toLowerCase() === email.toLowerCase());
};