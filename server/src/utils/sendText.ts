// import twilio from "twilio";

// const { TWILIO_SID, TWILIO_TOKEN, TWILIO_PHONE } = process.env;

// const client = twilio(TWILIO_SID, TWILIO_TOKEN);

export default ({ to, body }: { to: string[] | string, body: string}) => {
    // if (typeof to === 'string') to = [to];

    // to.map(number => {
    //     client.messages
    //         .create({
    //             body,
    //             from: TWILIO_PHONE,
    //             to: number
    //         })
    //         .then(message => console.log(message.sid));
    // });
}