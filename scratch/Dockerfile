ARG DEBIAN_VERSION=bookworm
ARG SHIMMY_VERSION=latest

FROM ghcr.io/lambda-feedback/shimmy:${SHIMMY_VERSION} as shimmy

FROM debian:${DEBIAN_VERSION}-slim as base

# set common workdir
WORKDIR /app

FROM base as lambda-rie

# Install curl
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install the AWS Lambda Runtime Interface Emulator
RUN case $(uname -m) in \
    "aarch64") export RIE_BINARY_NAME="aws-lambda-rie-arm64" ;; \
    *) export RIE_BINARY_NAME="aws-lambda-rie" ;; \
    esac && \
    curl -Lo /usr/local/bin/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/${RIE_BINARY_NAME} && \
    chmod +x /usr/local/bin/aws-lambda-rie

FROM base as final

ENV LOG_FORMAT="production"

# add shimmy
COPY --from=shimmy /shimmy /usr/local/bin/shimmy

# add aws-lambda-rie
COPY --from=lambda-rie /usr/local/bin/aws-lambda-rie /usr/local/bin/aws-lambda-rie

# Copy the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "shimmy" ]