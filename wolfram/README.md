# Wolfram Evaluation Function Base Image

This is the base image which is intended to be used by evaluation functions written in Wolfram Language. It is based on the [`wolframresearch/wolframengine`](https://hub.docker.com/r/wolframresearch/wolframengine) image and adds the necessary components to run evaluation functions written in Wolfram Language.

## Usage

This image is not meant to be run directly. Instead, it ought to be used as a base image for evaluation functions written in Wolfram Language. The evaluation function should be placed in the `/app` directory.

Here is an example of a `Dockerfile` that uses this image as a base:

```Dockerfile
FROM ghcr.io/lambda-feedback/evaluation-function-base/wolfram:latest

COPY ./function.wl /app/function.wl

CMD ["shimmy", "-i", "file", "-c", "wolframscript", "-a", "-f", "-a", "/app/function.wl"]
```
