FROM golang:1.17-alpine as builder

WORKDIR /tmp

RUN apk add --no-cache make gcc musl-dev linux-headers git
RUN git clone --depth 1 --branch release/1.1.2-rc.6 https://github.com/Fantom-foundation/go-opera.git && \
    cd go-opera && \
    make

FROM golang:1.17-alpine

WORKDIR /root/.opera

COPY --from=builder /tmp/go-opera/build /usr/local/bin

# ADD https://opera.fantom.network/mainnet.g /opt/genesis/
ADD https://files.fantom.network/mainnet-171200-pruned-mpt.g /opt/genesis
# ADD https://opera.fantom.network/testnet.g /opt/genesis/
ADD https://files.fantom.network/testnet-16200-full-mpt.g /opt/genesis

ENTRYPOINT ["opera"]

