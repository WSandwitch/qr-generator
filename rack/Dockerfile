
FROM ruby:2.7.0
ENV BUNDLER_VERSION=2.2.25

RUN apt-get update && apt-get install -y gcc g++ build-essential && apt-get clean

RUN gem install bundler -v 2.2.25

WORKDIR /app

COPY . ./
EXPOSE 9292
#RUN bundle check
RUN bundle install --full-index

CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "9292"]
