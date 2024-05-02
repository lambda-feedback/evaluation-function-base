# Evaluation Function Base Images

This repository contains base images for evaluation functions written in various languages. The images are intended to be used as base images for evaluation functions that are run in a containerized environment, such as AWS Lambda.

All base images come with [`shimmy`](https://github.com/lambda-feedback/shimmy) pre-installed. Shimmy is an application that allows to run arbitrary evaluation functions in any containerized environment, including AWS Lambda.

## Images

This repository contains the following images:

- [Scratch](./scratch): Base image for evaluation functions written in arbitrary languages.
- [Wolfram](./wolfram): Base image for evaluation functions written in Wolfram Language.

## Usage

The images in this repository are not intended to be used directly. Instead, they should be used as base images for evaluation functions. Please refer to the README file in each image's directory for specific usage instructions.

A Dockerfile for a hypothetical evaluation function written in `bash` could look like this:

```Dockerfile
FROM ghcr.io/lambda-feedback/evaluation-function-base/scratch:latest

COPY ./eval.sh /app/eval.sh

RUN chmod +x /app/eval.sh

CMD ["shimmy", "-c", "/app/eval.sh"]
```
