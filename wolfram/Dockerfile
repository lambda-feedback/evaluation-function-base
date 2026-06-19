ARG SHIMMY_VERSION=latest
ARG WOLFRAM_ENGINE_VERSION=14.3

FROM ghcr.io/lambda-feedback/shimmy:${SHIMMY_VERSION} AS shimmy

FROM debian:bookworm-slim AS lambda-rie

# Install curl
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install the AWS Lambda Runtime Interface Emulator
RUN case $(uname -m) in \
    "aarch64") export RIE_BINARY_NAME="aws-lambda-rie-arm64" ;; \
    *) export RIE_BINARY_NAME="aws-lambda-rie" ;; \
    esac && \
    curl -Lfo /usr/local/bin/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/${RIE_BINARY_NAME} && \
    chmod +x /usr/local/bin/aws-lambda-rie

# FROM wolframresearch/wolframengine:${WOLFRAM_ENGINE_VERSION}
FROM --platform=linux/amd64 jonmcloone/wwe:Lab143Apr28

ARG WOLFRAM_ENGINE_VERSION

ENV LOG_FORMAT="production"

# set common workdir
WORKDIR /app

# add wstp server to path
ENV PATH=$PATH:/usr/local/Wolfram/WolframEngine/${WOLFRAM_ENGINE_VERSION}/SystemFiles/Links/WSTPServer

# add shimmy
COPY --from=shimmy /shimmy /usr/local/bin/shimmy

# add rie
COPY --from=lambda-rie /usr/local/bin/aws-lambda-rie /usr/local/bin/aws-lambda-rie

# add entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

# add entrypoint script
ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "shimmy" ]