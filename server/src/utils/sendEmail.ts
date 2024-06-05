import type React from "react";
import { Resend } from "resend";

const resend = new Resend(process.env.RESEND_API_KEY as string);

export default async ({ to, subject, body }: { to: string, subject: string, body: JSX.Element }) => {
    const {data, error} = await resend.emails.send({
        from: `No Reply <${process.env.NO_REPLY_ADDRESS as string}>`,
        to,
        subject,
        react: body,
    });
}