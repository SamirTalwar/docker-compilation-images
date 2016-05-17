# Docker Compilation Images

Compile your application in Docker, and ship your application as an image. Without shipping the build.

*Note: This is very much a proof of concept—a hacky Ruby script that has little to no error-handling and hasn't really been tested much. Use at your own risk.*

That said, if you do want to use it, you can of course run it as a a Docker image:


    docker run \
        --rm \
        --volume=/usr/local/bin/docker:/usr/local/bin/docker:ro \
        --volume=/var/run/docker.sock:/var/run/docker.sock:ro \
        --volume=$PWD:/app:ro \
        samirtalwar/docker-compilation-images \
        --tag=build=my-app-build
        --tag=run=my-app
        app

---

Say you have an application. Here's one in Go.

    package main

    import "fmt"

    func main() {
        fmt.Println("Hello, 世界")
    }

For consistency between development and production, it's becoming more and more common to run such an application inside a Docker container. And for consistency between developer machines, as well as continuous integration, it's becoming popular to build it in one too.

Building this in Docker is simple. All we need is a *Dockerfile*:

    FROM golang:onbuild

Seriously, that's it. The `golang:onbuild` image is configured to copy the source files in, build them and spit out an application contained inside the image at */usr/bin/app*.

Now, here's the problem.

    $ docker build --tag=app .
    ...
    $ docker inspect -f '{{ .VirtualSize }}' app
    746433139

…

Our final Docker image is over 700 MB, which makes pushing it around pretty heavy. It also has a massive surface area—a running container has, among other things, a compiler sitting inside it *and* the source code to our application. While I wouldn't suggest that you could easily yank the source code out of the container, if you did find your way onto my servers, I'm sure it'd be a nice bonus.

This is where compilation images come in.

---

Here's a Dockerfile that takes advantage of compilation images.

    NAME build
    FROM golang:onbuild

    NAME run
    FROM busybox
    WORKDIR /app
    COPY build:/go/bin/app .
    CMD ["./app"]

This is really two Dockerfiles stuck together, but with a twist: the later images can reference earlier ones. This means that you can build your application in Docker, then easily yank the final product out with a souped-up `COPY` directive and add it to a minimal image. Here, we're using `busybox`, which is about as tiny as you can get.

Our new size?

    $ ./docker-build --tag=run=app .
    ...
    $ docker inspect -f '{{ .VirtualSize }}' app
    3400732

3 MB. Busybox (approximately 1 MB) plus our application binary. That's it. No fluff, less attack surface and I can push it to my registry in no time.

---

[Thanks to @sheerun for the `NAME` and `COPY` syntax used in this project.](https://github.com/docker/docker/issues/13026#issuecomment-161322372)
