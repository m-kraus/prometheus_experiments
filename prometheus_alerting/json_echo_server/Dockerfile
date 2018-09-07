FROM golang:1.11
WORKDIR /go/src/app
COPY ./json_echo_server.go .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /json_echo_server .

#FROM alpine:3.8
FROM scratch
COPY --from=0 /json_echo_server /json_echo_server
EXPOSE 9093
ENTRYPOINT ["/json_echo_server"]
