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

# Build nsjail from source, on the same Debian release as the runtime image so
# the glibc / libstdc++ / libprotobuf ABIs match. shimmy ships the --sandbox
# feature but not the nsjail binary, so without this SANDBOX_ENABLED=true makes
# shimmy fail at startup (missing /usr/sbin/nsjail). Mirrors shimmy's own
# nsjail-builder stage. Dormant unless a function opts into --sandbox.
FROM python:${PYTHON_VERSION}-slim-${DEBIAN_VERSION} AS nsjail-builder
RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf bison flex g++ gcc git libtool make pkg-config \
        libcap-dev libnl-route-3-dev libprotobuf-dev protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*
ARG NSJAIL_VERSION=3.4
RUN git clone --branch "${NSJAIL_VERSION}" --recurse-submodules --depth=1 \
        https://github.com/google/nsjail.git /nsjail-src \
    && make -C /nsjail-src -j"$(nproc)"

FROM base AS lambda-rie

# Install the AWS Lambda Runtime Interface Emulator
RUN case $(uname -m) in \
    "aarch64") export RIE_BINARY_NAME="aws-lambda-rie-arm64" ;; \
    *) export RIE_BINARY_NAME="aws-lambda-rie" ;; \
    esac && \
    curl -Lo /usr/local/bin/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/${RIE_BINARY_NAME} && \
    chmod +x /usr/local/bin/aws-lambda-rie

FROM base

# git: install python packages from git repositories.
# libcap2 / libnl-route-3-200 / libprotobuf32: nsjail's runtime shared libraries.
RUN apt-get update && apt-get install -y \
    git \
    libcap2 \
    libnl-route-3-200 \
    libprotobuf32 \
    && rm -rf /var/lib/apt/lists/*

ENV LOG_FORMAT="production"

# add shimmy
COPY --from=shimmy /shimmy /usr/local/bin/shimmy

# add nsjail (used by shimmy's --sandbox / SANDBOX_ENABLED)
COPY --from=nsjail-builder /nsjail-src/nsjail /usr/sbin/nsjail

# add aws-lambda-rie
COPY --from=lambda-rie /usr/local/bin/aws-lambda-rie /usr/local/bin/aws-lambda-rie

# Copy the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

# fail the build if nsjail is missing a shared library
RUN ! ldd /usr/sbin/nsjail | grep -q 'not found'

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "shimmy" ]
