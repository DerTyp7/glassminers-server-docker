FROM debian:12.11-slim

RUN apt-get update && apt-get install -y wget

ENV MAX_LOGS="20"
ENV LOG_DIR="/var/log/glassminers"
ENV LOG_DATE_FORMAT="%Y-%m-%d-%H-%M-%S"

RUN mkdir -p ${LOG_DIR}

WORKDIR "/usr/local/bin/glassminers"

COPY ./scripts/download_server.sh ./
COPY ./scripts/run_server.sh ./

RUN chmod 777 ./*.sh
RUN ./download_server.sh

CMD ["./run_server.sh"]

EXPOSE 9876