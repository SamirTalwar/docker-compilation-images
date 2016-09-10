NAME build
FROM ruby
WORKDIR /usr/src/app
RUN bundle config --global frozen 1
COPY Gemfile ./
COPY Gemfile.lock ./
RUN bundle install --path=.bundle

FROM ruby:alpine
WORKDIR /app
COPY build:/usr/src/app/.bundle ./.bundle/
COPY docker-build ./
ENV GEM_PATH /app/.bundle/ruby/2.3.0
ENTRYPOINT ["./docker-build"]
