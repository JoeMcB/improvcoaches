FROM heroku/heroku:20

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -qq  && apt-get install -y \
    build-essential \
    libpq-dev \
    gcc \
    zsh \
    libv8-dev \
    nodejs \
    ruby2.7-dev \
    zlib1g-dev \
    vim \
    git

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# RUN apt remove -y --purge ruby \
#   && curl -s --retry 3 -L https://heroku-buildpack-ruby.s3.amazonaws.com/heroku-20/ruby-2.7.3.tgz | tar -xz \
#   && gem uninstall bundler rake

RUN gem install bundler -v 1.17.3 --force
RUN gem install rake  -v 12.3.3

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
