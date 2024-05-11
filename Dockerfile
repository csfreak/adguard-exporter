FROM golang:1.21-alpine as build
ARG TARGETOS
ARG TARGETARCH

WORKDIR /tmp/adguard_exporter

RUN apk --no-cache add git alpine-sdk ca-certificates
COPY . .
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags '-s -w' -o adguard_exporter ./

FROM scratch
LABEL name="adguard-exporter"

WORKDIR /root
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /tmp/adguard_exporter/adguard_exporter adguard_exporter

CMD ["./adguard_exporter"]
