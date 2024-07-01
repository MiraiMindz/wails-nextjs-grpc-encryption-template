"use client";

import { useState } from "react";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { Button } from "@/components/ui/button";
import {
    Form,
    FormControl,
    FormDescription,
    FormField,
    FormItem,
    FormLabel,
    FormMessage,
} from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { ThemeToggle } from "@/components/ThemeToggle";
import { getRoute } from "@/lib/utils";
import { Decrypt, Encrypt, LoadPrivateRSAKey, LoadPublicRSAKey, Base64Decode, Base64Encode } from "@/lib/crypto/crypto";

const publicApiRSAKeyPEM: string = process.env.NEXT_PUBLIC_API_PUBLIC_KEY!;
const privateFrontEndRSAKeyPEM: string = process.env.NEXT_PUBLIC_FRONTEND_PRIVATE_KEY!;
const RSAKeysPassword: string = process.env.NEXT_PUBLIC_KEYS_PASSWORD!;

const publicAPIRSAKey = LoadPublicRSAKey(publicApiRSAKeyPEM);
const privateFrontendRSAKey = LoadPrivateRSAKey(privateFrontEndRSAKeyPEM, RSAKeysPassword);

const formSchema = z.object({
    message: z.string().min(1, {
        message: "Please provide a message.",
    }),
})

export default function Home() {
    const [postResult, setPostResult] = useState<string>("");

    const form = useForm<z.infer<typeof formSchema>>({
        resolver: zodResolver(formSchema),
        defaultValues: {
            message: "",
        },
    })

    const handleSubmit = async (values: z.infer<typeof formSchema>) => {
        const result = formSchema.safeParse(values);
        if (!result.success) {
            const errors = result.error.errors;
            // Find the first invalid section
            console.log(errors)
        }

        const message: string = result.data?.message!;
        const encryptedMessage: string = Encrypt(publicAPIRSAKey, message);

        const pResponse = await fetch(getRoute(`/api/test`), {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ message: Base64Encode(encryptedMessage) })
        });

        if (!pResponse.ok) {
            throw new Error("[POST handleSubmit] Network response was not ok");
        }

        const pTextResult = await pResponse.json();

        const responseMessage: string = pTextResult.message!;
        const decodedMessage: string = Base64Decode(responseMessage);
        const decryptedMessage: string = Decrypt(privateFrontendRSAKey, decodedMessage);

        setPostResult(decryptedMessage);
    }

    return (
        <main className="w-full h-full flex justify-center items-center flex-col">
            <div className="mb-16 flex justify-center items-center flex-col">
                <h1 className="text-6xl font-bold mb-2"><span className="bg-gradient-to-tr from-cyan-300 to-blue-500 bg-clip-text text-transparent">Golang</span> & <span className="bg-gradient-to-tr from-red-600 to-orange-400 bg-clip-text text-transparent">Wails</span> + <span className="bg-gradient-to-tr from-slate-900 to-slate-700 dark:from-slate-50 dark:to-slate-300 bg-clip-text text-transparent">Next.JS</span></h1>
                <h1 className="text-3xl font-bold">With <span className="bg-gradient-to-tr from-indigo-500 to-purple-700 bg-clip-text text-transparent">Protocol Buffers</span>, <span className="bg-gradient-to-tr from-green-600 to-emerald-400 bg-clip-text text-transparent">gRPC</span> and <span className="bg-gradient-to-tr from-orange-400 to-yellow-500 bg-clip-text text-transparent">REST</span>.</h1>
            </div>
            <div className="w-2/5 h-fit">
                <div className="border rounded-md p-4 w-full border-slate-400 mb-8">
                    <div className="flex justify-between items-center w-full">
                        <h1 className="text-xl font-bold">Interaction Form</h1>
                        <ThemeToggle/>
                    </div>
                    <Form {...form}>
                        <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-8">
                            <FormField
                                control={form.control}
                                name="message"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>Message</FormLabel>
                                        <FormControl>
                                            <Input placeholder="Enter your Message" {...field} />
                                        </FormControl>
                                        <FormDescription>
                                            This is your message.
                                        </FormDescription>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />
                            <Button type="submit" className="w-full">Submit</Button>
                        </form>
                    </Form>
                </div>

                <div>
                    <h1 className="font-bold text-xl mb-2">The gRPC server response to your message was:</h1>
                    <div className="border rounded-md p-2 w-full min-h-16 border-slate-400 flex justify-center items-center">
                        <h1>{postResult}</h1>
                    </div>
                </div>
            </div>

        </main>
    );
}
