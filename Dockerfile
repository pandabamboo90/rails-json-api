# gets the docker image of ruby 2.7 and lets us build on top of that
FROM ruby:3.1.0-slim

# Installation of dependencies
RUN apt-get update -qq \
  && apt-get install -y \
    # Needed for certain gems
    build-essential \
    # Needed for postgres gem
    libpq-dev \
    # Needed for asset compilation
    git \
    # The following are used to trim down the size of the image by removing unneeded data
  && apt-get clean autoclean \
  && apt-get autoremove -y

# create a folder /src in the docker container and go into that folder
RUN mkdir /src
WORKDIR /src

# Copy the Gemfile and Gemfile.lock from app root directory into the /src/ folder in the docker container
COPY Gemfile /src/Gemfile
COPY Gemfile.lock /src/Gemfile.lock

# Run bundle install to install gems inside the gemfile
RUN bundle install

# Copy the whole app
COPY . /src

# Set correct permission for entrypoint file
RUN chmod +x entrypoint.sh
