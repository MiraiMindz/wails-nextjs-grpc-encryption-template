#!/usr/bin/env bash

if [[ "$(basename "$(pwd)")" == "scripts" ]]; then
    cd ..
fi

bash ./scripts/generate-protocolbuffers.sh
bash ./scripts/set-env.sh
bash ./scripts/gen-rsa-keys.sh

read -p "Do you want to create Github Repos with Submodules [y/n]? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "\n"
    bash ./scripts/initialize-submodules.sh
fi
