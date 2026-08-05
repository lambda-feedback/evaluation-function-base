ARG SHIMMY_VERSION=latest
ARG WWE=jonmcloone/wwe:LabJul1

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

FROM --platform=linux/amd64 ${WWE}

ARG WOLFRAM_ENGINE_VERSION=15.0
ARG TOOLKIT_WOLFRAM_VERSION=v1.2.0

ENV LOG_FORMAT="production"

# set common workdir
WORKDIR /app

# add wstp server to path
ENV PATH=$PATH:/usr/local/Wolfram/WolframEngine/${WOLFRAM_ENGINE_VERSION}/SystemFiles/Links/WSTPServer

# add the shared Wolfram evaluation-function toolkit (JSON comms layer),
# used by all Wolfram-based evaluation functions via PacletDirectoryLoad.
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN git clone --branch ${TOOLKIT_WOLFRAM_VERSION} --depth 1 \
      https://github.com/lambda-feedback/toolkit-wolfram.git /opt/lambda-feedback/toolkit-wolfram

ENV LF_TOOLKIT_PATH="/opt/lambda-feedback/toolkit-wolfram"

# Every Wolfram evaluation function follows the same shape: an evaluate.m
# and preview.m providing evaluate`EvaluationFunction / preview`PreviewFunction.
# Bootstrap.wl (shipped by toolkit-wolfram, cloned above) is the one fixed
# entry point that wires those into the toolkit's ServeEvaluationFunction --
# evaluation function repos only need to COPY their evaluate.m/preview.m
# into WORKDIR, not their own entry script.
ENV FUNCTION_COMMAND="wolframscript"
ENV FUNCTION_ARGS="-f,/opt/lambda-feedback/toolkit-wolfram/Bootstrap.wl"

# add shimmy
COPY --from=shimmy /shimmy /usr/local/bin/shimmy

# add rie
COPY --from=lambda-rie /usr/local/bin/aws-lambda-rie /usr/local/bin/aws-lambda-rie

# add entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

# add entrypoint script
ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "shimmy" ]