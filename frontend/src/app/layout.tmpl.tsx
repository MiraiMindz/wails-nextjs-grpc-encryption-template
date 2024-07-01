import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

import { ThemeProvider } from "@/components/ThemeProvider";
import Script from "next/script";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
    title: "{{.ProjectName}}",
    description: "{{.ProjectName}}",
};

export default function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    return (
        <html lang="en" suppressHydrationWarning>
            <body className={`${inter.className} w-screen h-screen scroll-smooth`}>
                <Script src="https://cdn.jsdelivr.net/npm/node-forge@latest/dist/forge.all.min.js" crossOrigin="anonymous" />
                <Script src="https://code.jquery.com/jquery-3.7.1.min.js" crossOrigin="anonymous" />
                <ThemeProvider
                    attribute="class"
                    defaultTheme="system"
                    enableSystem
                >
                    <div className="w-full h-full bg-gradient-to-tr from-slate-50 to-slate-300 dark:from-slate-900 dark:to-slate-700">
                        {children}
                    </div>
                </ThemeProvider>
            </body>
        </html>
    );
}
