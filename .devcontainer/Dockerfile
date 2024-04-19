FROM ruby:2.7.1

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ America/New_York
ENV GEM_HOME=/usr/local/bundle
ENV PATH="$GEM_HOME/bin:$PATH"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt-get install -y vim zsh git fonts-font-awesome libpq-dev build-essential libssl-dev libreadline-dev zlib1g-dev curl

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Install Bundler
RUN gem install bundler -v 2.4.0 && gem update --system 3.2.3

WORKDIR /workspace

COPY Gemfile /workspace/Gemfile
COPY Gemfile.lock /workspace/Gemfile.lock

# Install the gems in the current Ruby environment
RUN bundle config set --local path "$GEM_HOME" && \
    bundle install

# Install Yarn
RUN npm install -g yarn

RUN git config --global --add safe.directory /workspace

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb