import * as forge from "node-forge";

export function LoadPrivateRSAKey(keyPEM: string, password?: string): forge.pki.rsa.PrivateKey {
    const rsaPrivateKey = forge.pki.decryptRsaPrivateKey(keyPEM, password);
    return rsaPrivateKey;
}

export function LoadPublicRSAKey(keyPEM: string): forge.pki.rsa.PublicKey {
    const rsaPrivateKey = forge.pki.publicKeyFromPem(keyPEM);
    return rsaPrivateKey;
}

export function Encrypt(publicKey: forge.pki.rsa.PublicKey, data: string): string {
    const encryptedData: string = publicKey.encrypt(data, 'RSA-OAEP', {md: forge.md.sha512.create()});
    return encryptedData;
}

export function Decrypt(privateKey: forge.pki.rsa.PrivateKey, encryptedData: string): string {
    const decryptedData: string = privateKey.decrypt(encryptedData, 'RSA-OAEP', {md: forge.md.sha512.create()});
    return decryptedData;
}

export function Base64Decode(data: string): string {
    const encoded: string = forge.util.decode64(data);
    return encoded;
}

export function Base64Encode(data: string): string {
    const encoded: string = forge.util.encode64(data);
    return encoded;
}
