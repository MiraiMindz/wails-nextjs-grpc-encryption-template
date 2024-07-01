#!/usr/bin/env bash

if ! command -v protoc &> /dev/null; then
    printf "%s\n" "protoc not installed, please install it"
    exit 1
fi

if ! command -v go &> /dev/null; then
    printf "%s\n" "Golang not installed, please install it"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    printf "%s\n" "Node Package Manager (NPM) not installed, please install it"
    exit 1
fi

if [[ "$(basename "$(pwd)")" == "scripts" ]]; then
    cd ..
fi

printf "GENERATING PROTOCOL BUFFERS v3"

go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

cd ./frontend
npm install
cd ..

protoc --go_out=./backend --go-grpc_out=./backend ./protocolbuffers/*.proto
protoc --go_out=./server --go-grpc_out=./server ./protocolbuffers/*.proto

if [ ! -d ./frontend/src/proto ]; then
    mkdir -p ./frontend/src/proto
fi

rm -rf ./frontend/src/proto/*.proto
cp -r ./protocolbuffers/*.proto ./frontend/src/proto/
cd ./frontend
npm run proto-gen-types
cd ..

printf "%s\n" "DONE"