#!/usr/bin/env bash

if [[ "$(basename "$(pwd)")" == "scripts" ]]; then
    cd ..
fi

printf "SETTING LOCAL ENVIRONMENT VARIABLES"

cd ./frontend

touch .env.local

printf "NEXT_PUBLIC_ENVIRONMENT=\"WAILS\"\n" >> .env.local
printf "NEXT_PUBLIC_WAILS_SERVER_ADDRESS=\"http://localhost:1323\"\n" >> .env.local

printf "%s\n" "DONE"