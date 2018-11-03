FROM heroku/heroku:16
RUN echo "America/New_York" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

ENV APP_HOME /improvcoaches

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN apt-get update && apt-get install -y build-essential libpq-dev gcc ruby-dev libv8-dev nodejs
RUN export LD_LIBRARY_PATH=/usr/lib && gem install bundler

COPY Gemfile* ./
RUN  bundle install --jobs 4 --retry 5

EXPOSE 3000

CMD rails s
