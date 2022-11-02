FROM alpine:latest AS mirror

RUN apk add --no-cache --initdb \
        git \
        go \
        musl-dev \
        linux-headers \
    && true
ENV GOPATH=/go PATH=$PATH:/go/bin GOOS=linux

RUN git clone https://github.com/inetaf/tcpproxy /go/src/tcpproxy
WORKDIR /go/src/tcpproxy
RUN go build ./cmd/tlsrouter
RUN go install ./cmd/tlsrouter

RUN mkdir -p /out/usr/bin /out/etc/tlsrouter
RUN cp /go/bin/tlsrouter /out/usr/bin/
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
