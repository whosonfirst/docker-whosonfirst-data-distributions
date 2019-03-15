FROM whosonfirst-data-distributions-tools:latest

RUN mkdir -p /usr/local/data/dist

RUN apk update && apk upgrade \
    && apk add git git-lfs

COPY bin/build-distributions /usr/local/bin/