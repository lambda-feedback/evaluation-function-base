ARG DEBIAN_VERSION=bookworm
ARG SHIMMY_VERSION=latest

FROM debian:${DEBIAN_VERSION}-slim

# set common workdir
WORKDIR /app

# add shimmy
COPY --from=ghcr.io/lambda-feedback/shimmy:${SHIMMY_VERSION} /shimmy /usr/local/bin/shimmy
