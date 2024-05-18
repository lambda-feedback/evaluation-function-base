ARG SHIMMY_VERSION=latest
ARG WOLFRAM_ENGINE_VERSION=13.3

FROM ghcr.io/lambda-feedback/shimmy:${SHIMMY_VERSION} as shimmy

FROM debian:bookworm-slim as lambda-rie

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

FROM wolframresearch/wolframengine:${WOLFRAM_ENGINE_VERSION}

ENV LOG_FORMAT="production"

# Configure Wolfram to use /tmp/home as the home directory
ENV WOLFRAM_USERBASEDIRECTORY="/tmp/home"
ENV WOLFRAM_USERDOCUMENTSDIRECTORY="/tmp/home/Documents"
ENV WOLFRAM_DOCUMENTSDIRECTORY="/tmp/home/Documents"
ENV MATHEMATICA_USERBASE="/tmp/home/.WolframEngine"
ENV MATHEMATICAPLAYER_USERBASE="/tmp/home/.WolframEngine"
ENV WOLFRAMSCRIPT_CONFIGURATIONPATH="/tmp/home/.config/Wolfram/WolframScript/WolframScript.conf"
ENV WOLFRAMSCRIPT_AUTHENTICATIONPATH="/tmp/home/.cache/Wolfram/WolframScript"
ENV WOLFRAM_CACHEBASE="/tmp/home/.cache/Wolfram"
ENV WOLFRAM_LOG_DIRECTORY="/tmp/home/.Wolfram/Logs"

USER root

# TODO: look into why / if this is necessary
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

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