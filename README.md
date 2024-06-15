# Evaluation Function Base Images

This repository contains base images for evaluation functions written in various languages. The images are intended to be used as base images for evaluation functions that are run in a containerized environment, such as AWS Lambda.

All base images come with [Shimmy](https://github.com/lambda-feedback/shimmy) pre-installed. Shimmy is an application that allows to run arbitrary evaluation functions in any containerized environment, including AWS Lambda.

## Images

This repository contains the following images:

- [Scratch](./scratch): Base image for evaluation functions written in arbitrary languages.
- [Wolfram](./wolfram): Base image for evaluation functions written in Wolfram Language.
- [Lean](./lean): Base image for evaluation functions written in Lean.
- [Python](./python): Base image for evaluation functions written in Python.

## Usage

The images in this repository are not intended to be used directly. Instead, they should be used as base images for evaluation functions. Please refer to the README file in each image's directory for specific usage instructions.

A Dockerfile for a hypothetical evaluation function written in `bash` could look like this:

```Dockerfile
FROM ghcr.io/lambda-feedback/evaluation-function-base/scratch:latest

ENV FUNCTION_COMMAND="/app/eval.sh"

COPY ./eval.sh /app/eval.sh

RUN chmod +x /app/eval.sh
```

## AWS Lambda

All base images in this repository are compatible with AWS Lambda. For local development, they also include the [AWS Lambda runtime interface emulator](https://github.com/aws/aws-lambda-runtime-interface-emulator). This allows to test the evaluation function locally before deploying it to AWS Lambda. The emulator can be enabled by setting the `AWS_LAMBDA_RIE` environment variable to `1`.

```Dockerfile
FROM ghcr.io/lambda-feedback/evaluation-function-base/scratch:latest

ENV FUNCTION_COMMAND="/app/eval.sh"

ENV AWS_LAMBDA_RIE=1

# ...
```
