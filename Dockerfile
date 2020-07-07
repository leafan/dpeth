# # Build Geth in a stock Go builder container
# FROM golang:1.10-alpine as builder

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
# RUN apk add --no-cache make gcc musl-dev linux-headers git

# ADD . /dpeth
# RUN cd /dpeth && make dpeth

# # Pull Geth into a second stage deploy alpine container
# FROM alpine:latest

# RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
# RUN apk add --no-cache ca-certificates
# COPY --from=builder /dpeth/build/bin/dpeth /usr/local/bin/

# EXPOSE 8545 8546 30303 30303/udp
# ENTRYPOINT ["dpeth"]




# New: copy localhost dpeth version

FROM ubuntu:18.04

ARG app
ENV app $app

WORKDIR /app

# copy genesis block data here. so no need to generate block data.
COPY .dpeth /root/.block0

# copy init setups
COPY .init.sh /app/init.sh

COPY build/bin/dpeth /app/${app}

EXPOSE 8545 8546 30303 30303/udp
ENTRYPOINT [ "/app/${app}" ]
