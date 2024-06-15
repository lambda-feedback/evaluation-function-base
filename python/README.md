# Python Evaluation Function Base Image

This is a minimal base image which can be used by evaluation functions written in [Python](https://www.python.org/). It is based on the [`python:3.10-slim`](https://hub.docker.com/_/python) image and adds the necessary components to run evaluation functions written in Python.

## Usage

This image is not meant to be run directly. Instead, it ought to be used as a base image for evaluation functions written in Python. The evaluation function should be placed in the `/app` directory.

Here is an example of a `Dockerfile` that uses this image as a base:

```Dockerfile
FROM ghcr.io/lambda-feedback/evaluation-function-base/python:latest

COPY evaluation_function.py /app/evaluation_function.py

CMD ["shimmy", "-c", "python", "-a", "-m", "evaluation_function"]
```
