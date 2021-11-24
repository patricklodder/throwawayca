FROM debian:buster
RUN apt-get update && apt-get -y install \
    openssl \
    && rm -rf /var/lib/apt/lists/*

ARG SUBJECT="/C=UN/ST=SOL/L=Moon/O=Base/OU=./CN=%CN%/emailAddress=noreply@example.com"

WORKDIR /ca
COPY src/* ./
RUN /bin/bash /ca/openssl.sh
