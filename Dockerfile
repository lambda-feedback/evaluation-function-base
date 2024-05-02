ARG WOLFRAM_ENGINE_VERSION=13.3

FROM wolframresearch/wolframengine:${WOLFRAM_ENGINE_VERSION}

USER root

# TODO: look into why this is necessary
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    && rm -rf /var/lib/apt/lists/*

# set common workdir
WORKDIR /app

# add entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

# add wstp server to path
ENV PATH=$PATH:/usr/local/Wolfram/WolframEngine/${WOLFRAM_ENGINE_VERSION}/SystemFiles/Links/WSTPServer

# add entrypoint script
ENTRYPOINT ["/entrypoint.sh"]