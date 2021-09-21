FROM golang:1.15-alpine as builder

WORKDIR /tmp

RUN apk add --no-cache make gcc musl-dev linux-headers git
RUN git clone --depth 1 --branch release/1.0.2-rc.5 https://github.com/Fantom-foundation/go-opera.git && \
    cd go-opera && \
    make

FROM golang:1.15-alpine

COPY --from=builder /tmp/go-opera/build /usr/local/bin

ENTRYPOINT ['opera']
