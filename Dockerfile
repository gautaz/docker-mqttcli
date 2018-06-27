FROM golang:1.10.3-alpine3.7 AS build

RUN apk add --no-cache git
RUN mkdir -p src/github.com/Sirupsen src/github.com/eclipse src/github.com/mattn src/github.com/urfave src/github.com/gautaz src/github.com/bitly
RUN git clone -q --single-branch --branch 0.0.3 https://github.com/gautaz/mqttcli.git src/github.com/gautaz/mqttcli

# `go get` is unable to deal with tags, so be it...
RUN git clone -q --single-branch --branch v1.0.5 https://github.com/Sirupsen/logrus.git src/github.com/Sirupsen/logrus
RUN git clone -q --single-branch --branch v1.1.1 https://github.com/eclipse/paho.mqtt.golang.git src/github.com/eclipse/paho.mqtt.golang
RUN git clone -q --single-branch --branch v0.0.9 https://github.com/mattn/go-colorable.git src/github.com/mattn/go-colorable
RUN git clone -q --single-branch --branch v1.20.0 https://github.com/urfave/cli.git src/github.com/urfave/cli
RUN git clone -q --single-branch --branch v0.0.3 https://github.com/mattn/go-isatty src/github.com/mattn/go-isatty
RUN git clone -q --single-branch --branch v0.5.0 https://github.com/bitly/go-simplejson src/github.com/bitly/go-simplejson

# no tag is available for golang packages, that feels alien to me...
RUN go get -u golang.org/x/crypto/ssh/terminal
RUN go get -u golang.org/x/net/proxy
RUN go get -u golang.org/x/net/websocket
RUN go get -u golang.org/x/sys/unix

RUN go build -o mqttcli src/github.com/gautaz/mqttcli/*.go

FROM alpine:3.7

COPY --from=build /go/mqttcli /usr/local/bin/mqttcli
ENTRYPOINT ["/usr/local/bin/mqttcli"]
CMD ["--help"]
