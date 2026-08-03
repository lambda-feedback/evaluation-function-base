# Wolfram Evaluation Function Base Image

This is the base image which is intended to be used by evaluation functions written in Wolfram Language. It is based on the [`wolframresearch/wolframengine`](https://hub.docker.com/r/wolframresearch/wolframengine) image and adds the necessary components to run evaluation functions written in Wolfram Language.

## Usage

This image is not meant to be run directly. Instead, it ought to be used as a base image for evaluation functions written in Wolfram Language.

Every Wolfram evaluation function follows the same shape: an `evaluate.m` and
`preview.m` defining `evaluate\`EvaluationFunction` and
`preview\`PreviewFunction` respectively. This image already wires those into
the shared [`toolkit-wolfram`](https://github.com/lambda-feedback/toolkit-wolfram)
comms layer via `FUNCTION_COMMAND`/`FUNCTION_ARGS` (pointing at
`toolkit-wolfram`'s `Bootstrap.wl`), so a consuming evaluation function repo
only needs to provide those two files:

```Dockerfile
FROM ghcr.io/lambda-feedback/evaluation-function-base/wolfram:latest

COPY ./evaluate.m /app/evaluate.m
COPY ./preview.m /app/preview.m
```

A repo that needs custom wiring instead of the standard `evaluate.m`/
`preview.m` convention can still override `FUNCTION_COMMAND`/`FUNCTION_ARGS`
to point at its own entry script.
