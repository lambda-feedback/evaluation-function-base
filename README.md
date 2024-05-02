# Wolfram Evaluation Function Base Image

This is the base image which is intended to be used by evaluation functions written in Wolfram Language. It is based on the `wolframresearch/wolframengine` image and adds the necessary components to run evaluation functions written in Wolfram Language.

## Usage

This image is not meant to be run directly. Instead, it ought to be used as a base image for evaluation functions written in Wolfram Language. The evaluation function should be placed in the `/app` directory.

The image comes with [`shimmy`](https://github.com/lambda-feedback/shimmy) pre-installed. Shimmy is an application that allows to run arbitrary evaluation functions in any containerized environment, including AWS Lambda.

Here is an example of a `Dockerfile` that uses this image as a base:

```Dockerfile
FROM ghcr.io/lambda-feedback/evaluation-function-image-wolfram:latest

COPY ./function.wl /app/function.wl

CMD ["shimmy", "-i", "file", "-c", "wolframscript", "-a", "/app/function.wl"]
```
