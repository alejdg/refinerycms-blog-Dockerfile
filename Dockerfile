FROM rails

RUN apt-get install imagemagick

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
RUN gem install rails --version 4.2.4
RUN bundle install

RUN rails new my_new_application -m http://refinerycms.com/t/edge

WORKDIR /usr/src/app/my_new_application

RUN echo "gem 'refinerycms-blog', git: 'https://github.com/refinery/refinerycms-blog', branch: 'master'" >> Gemfile
RUN bundle install
RUN rails generate refinery:blog
RUN  rails generate refinery:authentication:devise
RUN rake db:migrate
RUN rake db:seed

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
