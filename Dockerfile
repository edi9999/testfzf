FROM ubuntu:14.04
MAINTAINER Edgar Hipp <hipp.edg@gmail.com>


# apt-get
RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y --force-yes git curl build-essential libncurses-dev libgpm-dev

# Install Go 1.4
RUN cd / && curl \
    https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz | \
    tar -xz && mv go go1.4

ENV GOPATH /go
ENV GOROOT /go1.4
ENV PATH /go1.4/bin:$PATH

# Install nodejs4 to local apt-get registry

# Volume
VOLUME /go

# For i386 build
RUN apt-get install -y lib32ncurses5-dev && \
    cd $GOROOT/src && GOARCH=386 ./make.bash

RUN cd /go && git clone https://github.com/junegunn/fzf.git fzf && fzf/install && cp fzf/bin/fzf /bin/fzf

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 5.5.0

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

RUN cd /tmp && \
    curl -L -o- https://nodejs.org/dist/v4.2.6/node-v4.2.6-linux-x64.tar.gz > node.tar.gz && \
    tar xzvf node.tar.gz && \
    mv node-v4.2.6-linux-x64/bin/* /bin

RUN npm install -g mocha

COPY package.json /src/package.json
COPY node_modules /src/node_modules
COPY test.js /src/test.js

ENV TERM screen

# Default CMD
CMD echo "hello world"
