FROM ruby:3.2.3

RUN apt-get update -qq && apt-get install -y nodejs npm default-mysql-client watchman
RUN npm install -g yarn

WORKDIR /project/hotwire_sns

COPY Gemfile /project/hotwire_sns/Gemfile
COPY Gemfile.lock /project/hotwire_sns/Gemfile.lock

RUN bundle install

COPY . /project/hotwire_sns

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["./bin/dev"]
