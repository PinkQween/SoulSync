import Bun from "bun";

console.log(Buffer.from(await crypto.subtle.digest("SHA-512", new TextEncoder().encode(Bun.argv[2]))).toString("base64"));