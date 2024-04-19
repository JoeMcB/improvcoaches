FROM heroku/heroku:22

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ America/New_York

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt-get install -y zsh git fonts-font-awesome libpq-dev build-essential libssl-dev libreadline-dev zlib1g-dev nodejs ruby-full

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN curl -fsSL https://bun.sh/install | bash

# Install Ruby and Bundler
RUN gem install bundler

# Set the path where Bundler installs gems
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH

# Copy your application's Gemfile and Gemfile.lock into the image
COPY Gemfile Gemfile.lock ./

# Install your application's gems
RUN bundle check || bundle install

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb