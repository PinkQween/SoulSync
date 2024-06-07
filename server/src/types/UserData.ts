export default interface UserData {
    username: string;
    email: string;
    hashedPassword?: string;
    code: number;
    deviceID: string[];
    verified: boolean;
    temp: boolean;
    createdAt: number;
    token?: string;
    birthdate: string;
    preferences?: {
        gender: string;
        sex: string;
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
        sexuality: string;
        relationshipStatus: string;
    };
    friendMaking?: {
        likes?: string[];
        dislikes?: string[];
    };
    dating?: {
        likes?: string[];
        dislikes?: string[];
        isLocked?: boolean;
    }
    bio?: string
}