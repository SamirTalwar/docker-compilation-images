NAME build
FROM golang:onbuild

FROM busybox
WORKDIR /app
COPY build:/go/bin/app .
CMD ["./app"]
