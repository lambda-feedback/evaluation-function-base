ARG DEBIAN_VERSION=bookworm
ARG SHIMMY_VERSION=latest

FROM ghcr.io/lambda-feedback/shimmy:${SHIMMY_VERSION} as shimmy

FROM debian:${DEBIAN_VERSION}-slim

# set common workdir
WORKDIR /app

# add shimmy
COPY --from=shimmy /shimmy /usr/local/bin/shimmy
