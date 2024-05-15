# Lean Evaluation Function Base Image

This is the base image which is intended to be used by evaluation functions written in [Lean 4](https://github.com/leanprover/lean4). It is based on the [`debian:bookworm-slim`](https://hub.docker.com/_/debian) image and adds the necessary components to run evaluation functions written in Lean 4.

## Usage

This image is not meant to be run directly. Instead, it ought to be used as a base image for evaluation functions written in Lean 4. The evaluation function should be placed in the `/app` directory.

Here is an example of a `Dockerfile` that uses this image as a base:

```Dockerfile
FROM ghcr.io/lambda-feedback/evaluation-function-base/lean:latest

COPY . .

RUN lake build

CMD ["shimmy"]
```
