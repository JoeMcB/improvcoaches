FROM heroku/heroku:18

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -qq  && apt-get install -y \
    build-essential \
    libpq-dev \
    gcc \
    libv8-dev \
    nodejs \
    zlib1g-dev \
    ruby2.5-dev \
    vim \
    git

RUN apt remove -y --purge ruby \
  && curl -s --retry 3 -L https://heroku-buildpack-ruby.s3.amazonaws.com/heroku-18/ruby-2.7.2.tgz | tar -xz \
  && gem uninstall bundler rake

RUN gem install bundler -v 1.17.3 --force
RUN gem install rake  -v 12.3.3

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
