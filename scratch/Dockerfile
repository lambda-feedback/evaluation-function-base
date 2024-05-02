ARG DEBIAN_VERSION=bookworm

FROM debian:${DEBIAN_VERSION}-slim

# set common workdir
WORKDIR /app

# add shimmy
COPY --from=shimmy /shimmy /usr/local/bin/shimmy
