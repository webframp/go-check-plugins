FROM golang:alpine as builder

ENV PLUGINS_VERSION v0.33.0

WORKDIR /src
# hadolint ignore=DL3018
RUN apk add -U --no-cache git make && \
    git -c advice.detachedHead=false \
        clone https://github.com/mackerelio/go-check-plugins \
        --branch $PLUGINS_VERSION --depth 1

WORKDIR /src/go-check-plugins
RUN make build

# hadolint ignore=DL3007
FROM alpine:latest
COPY --from=builder /src/go-check-plugins/build/* /usr/local/bin/

