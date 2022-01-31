FROM ruby:3.1.0
WORKDIR /satellite-data
COPY . /satellite-data/
RUN bundle install

EXPOSE 3000