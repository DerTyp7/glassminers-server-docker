FROM debian:12.11-slim

# The server version can be either 'nightly' or 'stable' and will differ in the
# executable that is downloaded from github. These arguments are used at build-time
ARG SERVER_VERSION
ARG SERVER_PORT

RUN apt-get update && apt-get install -y wget

ENV MAX_LOGS="20"
ENV LOG_DIR="/var/log/glassminers"
ENV LOG_DATE_FORMAT="%Y-%m-%d-%H-%M-%S"

RUN mkdir -p ${LOG_DIR}

WORKDIR "/usr/local/bin/glassminers"

COPY ./scripts/download_server.sh ./
COPY ./scripts/server_script.sh ./

RUN chmod 777 ./*.sh
RUN echo Building glassminers sever $SERVER_VERSION
RUN ./download_server.sh $SERVER_VERSION

CMD [ "./server_script.sh" ]

EXPOSE $SERVER_PORT