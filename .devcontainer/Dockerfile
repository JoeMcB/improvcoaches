FROM heroku/heroku:20

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ America/New_York

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt-get install zsh git fonts-font-awesome ruby2.7-dev libpq-dev build-essential libssl-dev libreadline-dev zlib1g-dev nodejs -y 
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN curl -fsSL https://bun.sh/install | bash


RUN gem install bundler -v 2.4
ENV PATH /usr/local/bundle/bin:$PATH

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
