FROM golang:1.10.3-alpine3.7 AS build
RUN apk add --no-cache bash git
COPY build.sh /go/
RUN ./build.sh

FROM alpine:3.7
COPY --from=build /go/mqttcli /usr/local/bin/mqttcli
RUN adduser -D mqttcli
USER mqttcli
ENTRYPOINT ["/usr/local/bin/mqttcli"]
CMD ["--help"]
