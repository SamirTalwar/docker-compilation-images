NAME build
FROM golang:onbuild

NAME run
FROM busybox
WORKDIR /app
COPY build:/go/bin/app .
CMD ["./app"]
