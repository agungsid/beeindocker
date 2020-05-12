# Base image is in https://registry.hub.docker.com/_/golang/
# Refer to https://blog.golang.org/docker for usage
FROM golang:buster as builder

# ENV GOPATH /go
ENV APP_DIR=/go/github.com/agungsid/beeindocker

RUN mkdir -p ${APP_DIR}

WORKDIR ${APP_DIR}

COPY . .

# Build static binary
RUN CGO_ENABLED=0 go install -mod vendor -ldflags '-extldflags "-static"'

FROM alpine:3.11.6

ENV APP_DIR=/go/bin

RUN mkdir -p ${APP_DIR}

WORKDIR ${APP_DIR}

COPY --from=builder /go/bin/beeindocker .

ENTRYPOINT [ "./beeindocker" ]