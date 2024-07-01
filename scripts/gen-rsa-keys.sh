#!/usr/bin/env bash

if ! command -v openssl &> /dev/null; then
    printf "%s\n" "openssl not installed, please install it"
    exit 1
fi

if [[ "$(basename "$(pwd)")" == "scripts" ]]; then
    cd ..
fi

generate_random_string() {
    local length=$1
    tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c "$length"
}

randomPassword=$(generate_random_string 512)

createEnvFiles() {
    if [ ! -e ".env" ]; then
        touch .env
    fi

    cd ./frontend
    if [ ! -e ".env.local" ]; then
        sh ./scripts/set-env.sh
    fi

    cd ../server
    if [ ! -e ".env" ]; then
        touch .env
    fi

    cd ..
}

createFrontendKeys() {
    echo "CREATING FRONTEND KEYS"

    privateKey=$(openssl genpkey -algorithm RSA -pass pass:"${randomPassword}" -aes256 -pkeyopt rsa_keygen_bits:4096)
    pkcs8PrivateKey=$(echo "${privateKey}" | openssl pkcs8 -passin pass:"${randomPassword}" -inform PEM -outform PEM -topk8 -passout pass:"${randomPassword}")
    publicKey=$(echo "${privateKey}" | openssl rsa -pubout -passin pass:"${randomPassword}")

    cd ./frontend
    printf "\n" >> .env.local
    echo "NEXT_PUBLIC_KEYS_PASSWORD=\"${randomPassword}\"" >> .env.local
    echo "NEXT_PUBLIC_FRONTEND_PUBLIC_KEY=\"${publicKey}\"" >> .env.local
    echo "NEXT_PUBLIC_FRONTEND_PRIVATE_KEY=\"${pkcs8PrivateKey}\"" >> .env.local

    cd ..
    echo "KEYS_PASSWORD=\"${randomPassword}\"" >> .env
    echo "FRONTEND_PUBLIC_KEY=\"${publicKey}\"" >> .env
    echo "FRONTEND_PRIVATE_KEY=\"${pkcs8PrivateKey}\"" >> .env

    cd ./server
    echo "KEYS_PASSWORD=\"${randomPassword}\"" >> .env
    echo "FRONTEND_PUBLIC_KEY=\"${publicKey}\"" >> .env
    echo "FRONTEND_PRIVATE_KEY=\"${pkcs8PrivateKey}\"" >> .env

    cd ..

}

createAPIKeys() {
    echo "CREATING API KEYS"

    privateKey=$(openssl genpkey -algorithm RSA -pass pass:"${randomPassword}" -aes256 -pkeyopt rsa_keygen_bits:4096)
    pkcs8PrivateKey=$(echo "${privateKey}" | openssl pkcs8 -passin pass:"${randomPassword}" -inform PEM -outform PEM -topk8 -passout pass:"${randomPassword}")
    publicKey=$(echo "${privateKey}" | openssl rsa -pubout -passin pass:"${randomPassword}")

    cd ./frontend
    printf "\n" >> .env.local
    echo "NEXT_PUBLIC_API_PUBLIC_KEY=\"${publicKey}\"" >> .env.local
    echo "NEXT_PUBLIC_API_PRIVATE_KEY=\"${pkcs8PrivateKey}\"" >> .env.local

    cd ..
    echo "API_PUBLIC_KEY=\"${publicKey}\"" >> .env
    echo "API_PRIVATE_KEY=\"${pkcs8PrivateKey}\"" >> .env

    cd ./server
    echo "API_PUBLIC_KEY=\"${publicKey}\"" >> .env
    echo "API_PRIVATE_KEY=\"${pkcs8PrivateKey}\"" >> .env

    cd ..
}

createBackendKeys() {
    echo "CREATING BACKEND KEYS"

    privateKey=$(openssl genpkey -algorithm RSA -pass pass:"${randomPassword}" -aes256 -pkeyopt rsa_keygen_bits:4096)
    pkcs8PrivateKey=$(echo "${privateKey}" | openssl pkcs8 -passin pass:"${randomPassword}" -inform PEM -outform PEM -topk8 -passout pass:"${randomPassword}")
    publicKey=$(echo "${privateKey}" | openssl rsa -pubout -passin pass:"${randomPassword}")

    cd ./frontend
    printf "\n" >> .env.local
    echo "NEXT_PUBLIC_BACKEND_PUBLIC_KEY=\"${publicKey}\"" >> .env.local
    echo "NEXT_PUBLIC_BACKEND_PRIVATE_KEY=\"${pkcs8PrivateKey}\"" >> .env.local

    cd ..
    echo "BACKEND_PUBLIC_KEY=\"${publicKey}\"" >> .env
    echo "BACKEND_PRIVATE_KEY=\"${pkcs8PrivateKey}\"" >> .env

    cd ./server
    echo "BACKEND_PUBLIC_KEY=\"${publicKey}\"" >> .env
    echo "BACKEND_PRIVATE_KEY=\"${pkcs8PrivateKey}\"" >> .env

    cd ..
}

# variable=$(openssl genpkey -algorithm RSA -pass pass:1234 -aes256 -pkeyopt rsa_keygen_bits:4096)
createFrontendKeys
createAPIKeys
createBackendKeys
