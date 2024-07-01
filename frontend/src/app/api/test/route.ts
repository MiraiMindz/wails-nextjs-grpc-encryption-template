import { ChannelCredentials, Client } from "@grpc/grpc-js";
import { Test } from "@/lib/gRPC/Test";
import { promisify } from "util";
import { TestClient } from "@/proto/generated/test/Test";

const getGrpcClient = () => {
    if (process.env.GRPC_SERVER_HOST_NAME === undefined) {
        throw new Error("GRPC_SERVER_HOST_NAME is not set");
    }

    return new Test(
        `${process.env.GRPC_SERVER_HOST_NAME}:50051`,
        ChannelCredentials.createInsecure()
    );
};

const testFunc = promisify(
    (client: TestClient, request: { message: string }, callback: (error: Error | null, response: any) => void) => {
        client.TestFunc(request, callback);
    }
);

export async function POST(request: Request) {
    try {
        const client = getGrpcClient();

        const body = await request.json();
        const message = body.message;

        const response = await testFunc(client, { message });

        return new Response(JSON.stringify(response), {
            status: 200,
            headers: {
                'Content-Type': 'application/json'
            }
        });
    } catch (error) {
        console.error("gRPC call failed:", error);
        return new Response(JSON.stringify({ error: "Request has failed, check server logs!" }), {
            status: 500,
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }
}