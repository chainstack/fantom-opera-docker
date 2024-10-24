FROM golang:1.17-alpine as builder
WORKDIR /tmp
COPY opera-1.1.3-rc5.patch /tmp/

RUN apk add --no-cache make gcc musl-dev linux-headers git
RUN go clean -modcache
RUN git clone --depth 1 --branch release/1.1.3-rc.5 https://github.com/Fantom-foundation/go-opera.git

RUN cd go-opera && \
    git apply ../opera-1.1.3-rc5.patch && \
    make

FROM golang:1.17-alpine

WORKDIR /root/.opera

COPY --from=builder /tmp/go-opera/build /usr/local/bin

RUN mkdir /opt/genesis
RUN wget -O /opt/genesis/mainnet.g https://storage.googleapis.com/fantom-opera-genesis/mainnet.g
RUN wget -O /opt/genesis/testnet.g https://storage.googleapis.com/fantom-opera-genesis/testnet.g

ENTRYPOINT ["opera"]
