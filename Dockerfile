FROM golang:1.17-alpine as builder
WORKDIR /tmp

RUN apk add --no-cache make gcc musl-dev linux-headers git
RUN go clean -modcache
RUN git clone --depth 1 --branch master https://github.com/Fantom-foundation/go-opera.git && \
    cd go-opera && \
    make

FROM golang:1.17-alpine

WORKDIR /root/.opera

COPY --from=builder /tmp/go-opera/build /usr/local/bin

RUN mkdir /opt/genesis
RUN wget -O /opt/genesis/mainnet.g https://opera.fantom.network/mainnet.g
RUN wget -O /opt/genesis/testnet.g https://opera.fantom.network/testnet.g

ENTRYPOINT ["opera"]