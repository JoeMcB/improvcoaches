FROM heroku/heroku:18

ENV DEBIAN_FRONTEND noninteractive
ENV TZ America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -qq  && apt-get install -y \
    build-essential \
    libpq-dev \
    gcc \
    libv8-dev \
    nodejs \
    zlib1g-dev \
    ruby2.5-dev

RUN apt remove -y --purge ruby \
  && curl -s --retry 3 -L https://heroku-buildpack-ruby.s3.amazonaws.com/heroku-18/ruby-2.5.3.tgz | tar -xz \
  && gem uninstall bundler

ENV APP_HOME /improvcoaches

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* ./
RUN gem install bundler -v 1.17.3

RUN  bundle install --jobs 4 --retry 5

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
