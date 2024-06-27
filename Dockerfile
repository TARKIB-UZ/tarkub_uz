# # Step 1: Modules caching
# FROM golang:1.23rc1-alpine3.20 as modules
# COPY go.mod go.sum /modules/
# WORKDIR /modules
# RUN go mod download

# # Step 2: Builder
# FROM golang:1.23rc1-alpine3.20 as builder
# COPY --from=modules /go/pkg /go/pkg
# COPY . /app
# WORKDIR /app
# RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
#     go build -tags migrate -o /bin/app ./cmd/app

# # Step 3: Final
# FROM scratch
# COPY --from=builder /app/config /config
# COPY --from=builder /app/migrations /migrations
# COPY --from=builder /bin/app /app
# COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# CMD ["/app"]



FROM golang:1.20-alpine3.16 AS builder

RUN mkdir app
COPY . /app

WORKDIR /app

RUN go build -o main cmd/app/main.go

FROM alpine:3.16

WORKDIR /app

COPY --from=builder /app .

CMD ["/app/main"]