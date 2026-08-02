FROM ruby:3.4.10

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ America/New_York
ENV GEM_HOME=/usr/local/bundle
ENV PATH="$GEM_HOME/bin:$PATH"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt-get install -y vim zsh git fonts-font-awesome libpq-dev build-essential libssl-dev libvips-dev libreadline-dev zlib1g-dev curl 


# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_24.x | bash - && \
    apt-get install -y nodejs

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Match the Bundler version recorded in Gemfile.lock for reproducible builds.
RUN gem install bundler -v 4.0.17

WORKDIR /workspace

COPY Gemfile /workspace/Gemfile
COPY Gemfile.lock /workspace/Gemfile.lock

# Install the gems in the current Ruby environment
RUN bundle config set --local path "$GEM_HOME" && \
    bundle install

# Install Yarn
RUN npm install -g yarn@1.22.22

COPY package.json /workspace/package.json
COPY yarn.lock /workspace/yarn.lock
RUN yarn install --frozen-lockfile

RUN git config --global --add safe.directory /workspace

EXPOSE 3000

CMD ./bin/dev
