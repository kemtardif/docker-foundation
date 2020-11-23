FROM ruby:2.5.8

LABEL Name=rocketelevatorfoundation Version=0.0.1
 
ENV BUNDLER_VERSION 2.1.4

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1\
    mkdir /app

WORKDIR /app


COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

COPY init.sql /docker-entrypoint-initdb.d/
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /docker-entrypoint-initdb.d/init.sql
RUN chmod +x /usr/bin/docker-entrypoint.sh




RUN apt-get update -qq && apt-get install -y build-essential nodejs
RUN  apt-get install -y  libxml2-dev\
                        libxslt1-dev\
                        libmariadb-dev-compat\
                        libmariadb-dev\
                        default-libmysqlclient-dev\
                        postgresql-client\
                        libpq-dev

RUN gem update --system --quiet
RUN gem install bundler
RUN gem install tzinfo

RUN bundle check || bundle install

COPY . /app

ENTRYPOINT ["docker-entrypoint.sh"]









