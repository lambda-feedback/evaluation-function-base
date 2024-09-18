ARG DEBIAN_VERSION=bookworm
ARG SHIMMY_VERSION=latest
ARG PYTHON_VERSION=3.11

FROM ghcr.io/lambda-feedback/shimmy:${SHIMMY_VERSION} AS shimmy

FROM python:${PYTHON_VERSION}-slim-${DEBIAN_VERSION} AS base

# set common workdir
WORKDIR /app

# Install git so we can install python packages from git repositories
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

FROM base AS lambda-rie

# Install the AWS Lambda Runtime Interface Emulator
RUN case $(uname -m) in \
    "aarch64") export RIE_BINARY_NAME="aws-lambda-rie-arm64" ;; \
    *) export RIE_BINARY_NAME="aws-lambda-rie" ;; \
    esac && \
    curl -Lo /usr/local/bin/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/${RIE_BINARY_NAME} && \
    chmod +x /usr/local/bin/aws-lambda-rie

FROM base

# Install git so we can install python packages from git repositories
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

ENV LOG_FORMAT="production"

# add shimmy
COPY --from=shimmy /shimmy /usr/local/bin/shimmy

# add aws-lambda-rie
COPY --from=lambda-rie /usr/local/bin/aws-lambda-rie /usr/local/bin/aws-lambda-rie

# Copy the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "shimmy" ]