FROM golang:1.11-alpine AS build

RUN apk add --update --no-cache git
WORKDIR /src/
COPY . /src/
RUN cd /src/cmd/sops && CGO_ENABLED=0 go build -o /bin/sops
RUN chmod +x /bin/sops

FROM scratch
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /bin/sops /bin/sops
ENTRYPOINT ["/bin/sops"]
