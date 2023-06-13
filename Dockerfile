FROM ruby:3.1

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile* ./
RUN bundle install
COPY . /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
