import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';
import path from 'path';

import { ProtoGrpcType as TestServiceProtoGrpcType } from '@/proto/generated/Test';

const TEST_PROTO_PATH = path.join(process.cwd(), './src/proto/Test.proto');

const packageDefinition = protoLoader.loadSync(TEST_PROTO_PATH, {
    defaults: true,
    keepCase: true,
    oneofs: true,
});

const TestService = (
    grpc.loadPackageDefinition(packageDefinition) as unknown as TestServiceProtoGrpcType
).test;

const { TestRequest, TestResponse, Test } = TestService;

export { TestRequest, TestResponse, Test };