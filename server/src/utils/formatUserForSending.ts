import type UserData from "../types/UserData"

export default (user: UserData) => {
    delete user.hashedPassword
    return user
}