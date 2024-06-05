export default (success: boolean, body: any) => {
    return success == true ? {
        success,
        message: body
    } : {
        success,
        error: body
    }
}