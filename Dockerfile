FROM alpine:latest AS mirror

RUN apk add --no-cache --initdb \
        git                     \
        go                      \
        musl-dev                \
    		linux-headers           \
        upx                     \
    && true
ENV GOPATH=/go PATH=$PATH:/go/bin GOOS=linux

COPY tlsrouter /go/src/tlsrouter
WORKDIR /go/src/tlsrouter
RUN    go build -ldflags="-s -w" \
    && go install                \
    && upx /go/bin/tlsrouter

RUN    mkdir -p /out/usr/bin /out/etc/tlsrouter \
    && cp /go/bin/tlsrouter /out/usr/bin/
COPY entrypoint.sh /out/usr/bin/

FROM alpine:latest
ENTRYPOINT []
CMD []
RUN    apk add --no-cache \
        aws-cli \
        bash \
    && rm -rf /var/cache/apk/*
WORKDIR /
COPY --from=mirror /out/ /
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/usr/bin/tlsrouter", "-conf", "/etc/tlsrouter/tlsrouter.conf"]
