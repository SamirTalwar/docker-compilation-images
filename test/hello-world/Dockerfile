NAME build
FROM haskell
WORKDIR /build
COPY Hello.hs .
RUN ghc -o hello Hello.hs

NAME run
FROM fpco/haskell-scratch:integer-gmp
WORKDIR /app
COPY build:/build/hello .
CMD ["./hello"]
