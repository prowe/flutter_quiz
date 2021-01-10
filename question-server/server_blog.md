Serverless GraphQL

I have been deploying AWS Lambda functions for a long time. And for a long time it has been awkward to do so. There is a lot of boilerplate to get a Lambda out there:
- Any non-trivial lambda has multiple files and can't be embedded in the Cloudformation template. These files have to live in an S3 bucket, so we need a bucket and need to upload a zip of our code in it.
- We need to create a Role
- Depending on what invokes our Lambda, we have to create event handlers, or subscriptions, or Api Gateways
- The events that are fired into a Lambda aren't always obvious
- Running them locally has been difficult.

For these reasons, I tend to shy away from using Lambdas to back an HTTP Api, prefering instead to build a Docker container and deploy it to Fargate.

The Serverless Transform makes a lot of the above pain go away. And, if you are deploying via Cloudformation, I recommend it for all Lambda declorations. For this, we're going to take it a step further and use the Serverless Application Model Cli.

First, We need to install the CLI using the instructions. I'm on a Mac so I went with the homebrew instructions. This took a while.

Anytime I am experimenting with a new framework, language, or really creating a new project in general, I like to start with a "Hello World" app to make sure I have my dev environment setup right. So I'm going to start by creating an HTTP Api that returns that famous string.

I created a new empty directory and ran `sam init`. This prompted me for various questions to build a directory structure that the tooling expects. I answered the following to the questions:
1. AWS Quick Start Templates
2. Zip
3. nodejs12.x
4. question-server
5. Hello World example

This then created a new directory called "question-server" and created a few files:
- `template.yaml` for Cloudformation
- an `events` directory with a sample json file
- a `hello-world` directory with:
    - `package.json` for npm
    - `app.js` with the handler
    - a `tests` folder with a unit test that uses Chai.

I've got mixed feelings at this point. I don't know if I want every lambda to have its own `package.json`. But, I can't think of a great reason not to, so I'll wait and see. I'm not a big fan of Mocha/Chai/Sinon as a JS testing framework. I much prefer Jest. (I wonder how the Rome project is coming along?). So I think I'll take a detour and swap that out.

1. Install Jest by navigating to the `hello-world` folder and running `npm i --save-dev jest @types/jest`.
2. Delete the Chai and Mocha dependencies from `package.json`.
3. While we're here, update the `test` script to be `jest`.
4. I renamed the `hello-world/tests/unit/test-handler.js` file to be `hello-world/app.spec.js` to match the jest convention.
5. Run `npm test` and Jest should find `app.spec.js` and try to run it. It will fail because it's full of Mocha code.
5. Update `app.spec.js` to port it to Jest. I ended up with this:
    ```Javascript
    'use strict';
    const app = require('./app');

    let event;
    let context;

    it('verifies successful response', async () => {
        const result = await app.lambdaHandler(event, context)

        expect(typeof result).toEqual('object');
        expect(result.statusCode).toEqual(200);
        expect(typeof result.body).toEqual('string');

        let response = JSON.parse(result.body);

        expect(typeof response).toEqual('object');
        expect(response.message).toEqual("hello world");
    });
    ```

Ok, now lets look at the `app.js` it generated; Pretty simple, I find it wierd it is catching an exception and then returning it. It is also odd that is creating a global variable and assigning it instead of creating a local variable.

One of the things that interested me in the SAM cli was the ability to run functions locally. Let me give that a try by running `sam local start-api` from the top directory (the one with `template.yaml`). It logs that it is hosting our function at (http://127.0.0.1:3000/hello). I attempted to curl it and my sam terminal showed it started to build a docker container. So this first invocation will take a while. Once it built, I got the following back as expected:
```Json
{"message":"hello world"}
```

Creating and uploading a Zip file with source code is cumbersome. So I have been using `aws cloudformation package` to handle that for some time. The SAM CLI also advertises this feature. First I got some credentials to my AWS account. I also made sure I had an S3 bucket created that the artifacts can go into. Then I ran the sam deploy command:
```Bash
sam deploy \
    --region=us-east-2 \
    --stack-name=prowe-sam \
    --s3-bucket=prowe-sai-sandbox-dev-deploy \
    --capabilities=CAPABILITY_IAM \
    --no-fail-on-empty-changeset
```
Pretty much all of these flags are familiar from `aws cloudformation package` or `aws cloudformation deploy`. Not a suprise since I assume `sam deploy` just wraps those commands. Correction, it is much better. Unlike the aws cli, it actually logs the status of the cloudformation events and shows how they are created. That alone is worth switching. It even dumps the stack outputs at the end of the deploy. The auto generated template included the Api Gateway as an output so I clicked on that URL and got my hello-world from the cloud. At this point we have an "infinate scale" app.

Based on the terminal output, it does not appear that it downloads dependencies or runs unit tests. No big deal.

Sweet, So now, let's tear down this house we just built and swap it to use Apollo Sever to host Graphql. My plan is to start with a single Graphql "Server" and once it grows too big for a single Lambda then I'll split it into multiple repositories and use Apollo Federation to tie them together.

1. Create a `src` directory (since I'm only going to have one lambda).
2. Move `package.json` into the `src` directory.
  (I Tried to move package.json up a directory but then the `sam local start-api` wasn't able to find my dependencies.)
3. Install some dependencies `cs src && npm install --save apollo-server-lambda graphql`
4. Create a `src/app.js` file to host our graphql server and populate this content from [The apollo-server-lambda docs]:
    ```Javascript
    const { ApolloServer, gql } = require('apollo-server-lambda');

    // Construct a schema, using GraphQL schema language
    const typeDefs = gql`
      type Query {
          hello: String
      }
    `;

    // Provide resolver functions for your schema fields
    const resolvers = {
      Query: {
          hello: () => 'Hello world!',
      },
    };

    const server = new ApolloServer({ typeDefs, resolvers });

    exports.graphqlHandler = server.createHandler({
      cors: {
        origin: '*',
        credentials: true,
      },
    });
    ```
5. Add a new function declaration to `template.yaml`:
    ```YAML
    GraphQlFunction:
      Type: AWS::Serverless::Function
      Properties:
        CodeUri: src/
        Handler: app.graphqlHandler
        Runtime: nodejs12.x
        Events:
          PostRequest:
            Type: Api
            Properties:
              Path: /graphql
              Method: ANY
    ```
6. Delete the `HelloWorldFunction` resource and outputs from `template.yaml`
7. I had to up the `Timeout` property to 10 seconds so that the lambda could load locally without timing out.
7. Remote the `hello-world` directory.

Now, re-run `sam local start-api` (kill it if it is runnig from before). And we should see "Mounting GraphQlFunction at http://127.0.0.1:3000/graphql [DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT]". Go to (http://127.0.0.1:3000/graphql) and you should see the "GraphQL Playground" we can use to invoke our Api.