FROM debian:stretch-slim

# ARG BUILD_ARGUMENT=JustToRemember

ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
  && apt install -y \
    curl \
    netcat \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /docker-entrypoint-initdb.d

COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["echo", "hi"]
