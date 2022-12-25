FROM ruby:2.7.0
ENV BUNDLER_VERSION=2.2.25

RUN apt-get update && apt-get install -y gcc g++ build-essential && apt-get clean

RUN gem install bundler -v 2.2.25

WORKDIR /app

COPY . ./
EXPOSE 3000
RUN bundle check || bundle install

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
