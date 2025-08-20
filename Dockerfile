FROM debian:12.11-slim

# The server version can be either 'nightly' or 'stable' and will differ in the
# executable that is downloaded from github. These arguments are used at build-time
ARG SERVER_VERSION
ARG SERVER_PORT

# This one is used at run-time
ENV SERVER_VERSION ${SERVER_VERSION}

RUN apt-get update && apt-get install -y wget

ENV MAX_LOGS="20"
ENV LOG_DIR="/var/log/glassminers"
ENV LOG_DATE_FORMAT="%Y-%m-%d-%H-%M-%S"

RUN mkdir -p ${LOG_DIR}

WORKDIR "/usr/local/bin/glassminers"

COPY ./scripts/download_server.sh ./
COPY ./scripts/server_script.sh ./

RUN chmod 777 ./*.sh
RUN ./download_server.sh $SERVER_VERSION

CMD ./server_script.sh ${SERVER_VERSION}

EXPOSE $SERVER_PORT