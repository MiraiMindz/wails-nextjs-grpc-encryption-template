# {{.ProjectName}}

## About

This is a monolithic template that contains 3 parts, Server/, Backend/ and FrontEnd/ with submodule initialization scripts and automation tools for gRPC and Protocol Buffers for you to develop a Cross-Platform + Web app in a single codebase.

## Live Development

To run in live development mode, run `wails dev` in the project directory. In another terminal, go into the `frontend`
directory and run `npm run dev`. The frontend dev server will run on http://localhost:34115. Connect to this in your
browser and connect to your application.

## Building

To build a redistributable, production mode package, use `wails build`.

To deploy it to vercel, you will need to create the git submodules, deploy the front-end repo to vercel, and on the ENVIRONMENT VARIABLES section on the vercel deploy screen add the following:

```bash
NEXT_PUBLIC_ENVIRONMENT="VERCEL" # or any environment that is NOT wails.
NEXT_PUBLIC_WAILS_SERVER_ADDRESS="http://localhost:1323" # the address of the REST/gRPC Server.
```

and you are done, it will work just fine.

