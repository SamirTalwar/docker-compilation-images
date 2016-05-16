NAME build
FROM ruby

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --path=.bundle

COPY . /usr/src/app

NAME app
FROM ruby:slim
WORKDIR app
COPY build:/usr/src/app /app
ENV GEM_PATH /app/.bundle/ruby/2.3.0
CMD ["./get-example"]
