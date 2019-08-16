FROM golang:1.12-alpine as gotools

RUN mkdir /build

RUN apk update && apk upgrade \
    && apk add git make gcc libc-dev \
    #
    && cd /build \
    && git clone https://github.com/whosonfirst/go-whosonfirst-github.git \
    && cd go-whosonfirst-github && make tools \
    && mv bin/wof-clone-repos /usr/local/bin/ \
    && mv bin/wof-list-repos /usr/local/bin/ \    
    #
    && cd /build \
    && git clone https://github.com/whosonfirst/go-whosonfirst-dist.git \
    && cd go-whosonfirst-dist && make tools \
    && mv bin/wof-dist-build /usr/local/bin/ \
    #
    && cd /build \
    && git clone https://github.com/whosonfirst/go-whosonfirst-dist-publish.git \
    && cd go-whosonfirst-dist-publish && make tools \    
    && mv bin/wof-dist-index /usr/local/bin/ \
    && mv bin/wof-dist-publish /usr/local/bin/ \
    #
    && cd / && rm -rf build
    
FROM alpine

RUN mkdir -p /usr/local/data/dist

RUN apk update && apk upgrade \
    && apk add git py-pip \
    #
    && pip install awscli
    

COPY --from=gotools /usr/local/bin/wof-clone-repos /usr/local/bin/wof-clone-repos
COPY --from=gotools /usr/local/bin/wof-list-repos /usr/local/bin/wof-list-repos
COPY --from=gotools /usr/local/bin/wof-dist-build /usr/local/bin/wof-dist-build
COPY --from=gotools /usr/local/bin/wof-dist-index /usr/local/bin/wof-dist-index
COPY --from=gotools /usr/local/bin/wof-dist-publish /usr/local/bin/wof-dist-publish

COPY bin/wof-test-distributions /usr/local/bin/
COPY bin/wof-test-permissions /usr/local/bin/