export default interface UserData {
    username: string;
    phoneNumber: string;
    hashedPassword: string;
    code: number;
    deviceID: string[];
    verified: boolean;
    temp: boolean;
    createdAt: number;
    token: string;
    preferences?: {
        gender: string;
        sex: string;
        interests: string[];
        sexuality: string;
        relationshipStatus: string;
        ageRange: {
            min: number;
            max: number;
        };
    };
    details?: {
        gender: string;
        sex: string;
        interests: string[];
        sexuality: string;
        relationshipStatus: string;
    };
}