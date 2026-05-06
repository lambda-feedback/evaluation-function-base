ARG DEBIAN_VERSION=bookworm
ARG SHIMMY_VERSION=latest

FROM ghcr.io/lambda-feedback/shimmy:${SHIMMY_VERSION} AS shimmy

FROM debian:${DEBIAN_VERSION}-slim AS base

# set common workdir
WORKDIR /app

# curl & git is required to fetch the lean version specified in `lean-toolchain` if
# it differs from `LEAN_VERSION`, and to fetch external lake dependencies.
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

FROM base AS deps

# Install the AWS Lambda Runtime Interface Emulator
RUN case $(uname -m) in \
    "aarch64") export RIE_BINARY_NAME="aws-lambda-rie-arm64" ;; \
    *) export RIE_BINARY_NAME="aws-lambda-rie" ;; \
    esac && \
    curl -Lfo /usr/local/bin/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/${RIE_BINARY_NAME} && \
    chmod +x /usr/local/bin/aws-lambda-rie

FROM base

ENV LOG_FORMAT="production"
ENV ELAN_HOME=/usr/local/elan
ENV PATH=/usr/local/elan/bin:$PATH

ARG LEAN_VERSION=4.7.0

# Download elan and install Lean 4
RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y --no-modify-path --default-toolchain leanprover/lean4:${LEAN_VERSION}

# add shimmy
COPY --from=shimmy /shimmy /usr/local/bin/shimmy

# add rie
COPY --from=deps /usr/local/bin/aws-lambda-rie /usr/local/bin/aws-lambda-rie

# Copy the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

# add entrypoint script
ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "shimmy" ]