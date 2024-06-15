# Scratch Evaluation Function Base Image

This is a minimal base image which can be used with arbitrary evaluation functions. It is based on the [`debian:bookworm-slim`](https://hub.docker.com/_/debian) image.

## Usage

This image is not meant to be run directly. Instead, it ought to be used as a base image for arbitrary evaluation functions. The evaluation function should be placed in the `/app` directory.

Here is an example of a `Dockerfile` that uses this image as a base:

```Dockerfile
FROM ghcr.io/lambda-feedback/evaluation-function-base/scratch:latest

COPY ./eval.sh /app/eval.sh

RUN chmod +x /app/eval.sh

CMD ["shimmy", "-c", "/app/eval.sh"]
```
