FROM ruby:3.2.3

RUN apt-get update -qq && apt-get install -y nodejs npm default-mysql-client postgresql-client watchman
RUN npm install -g yarn

WORKDIR /project/hotwire_sns

COPY Gemfile /project/hotwire_sns/Gemfile
COPY Gemfile.lock /project/hotwire_sns/Gemfile.lock
COPY package.json /project/hotwire_sns/package.json
COPY yarn.lock /project/hotwire_sns/yarn.lock

RUN bundle install
RUN yarn install

COPY . /project/hotwire_sns

ENTRYPOINT ["/project/hotwire_sns/bin/docker-entrypoint"]

EXPOSE 3000

CMD ["./bin/rails", "server", "-e", "production", "-b", "0.0.0.0"]
