FROM ruby:2.6.1-alpine

# Set local timezone
RUN apk add --update tzdata && \
    cp /usr/share/zoneinfo/America/Santiago /etc/localtime && \
    echo "America/Santiago" > /etc/timezone

# Install essential Linux packages
RUN apk add --update --virtual runtime-deps postgresql-client nodejs libffi-dev readline imagemagick git file
RUN apk add --update --virtual build-deps build-base openssl-dev postgresql-dev libc-dev \
  linux-headers libxml2-dev libxslt-dev readline-dev make ruby-json

# Point Bundler at /gems. This will cause Bundler to re-use gems that have already been installed on the gems volume
ENV BUNDLE_PATH /copec-gems
ENV BUNDLE_HOME /copec-gems

# Increase how many threads Bundler uses when installing. Optional!
ENV BUNDLE_JOBS 4

# How many times Bundler will retry a gem download. Optional!
ENV BUNDLE_RETRY 3

# Where Rubygems will look for gems, similar to BUNDLE_ equivalents.
ENV GEM_HOME /copec-gems
ENV GEM_PATH /copec-gems

# You'll need something here. For development, you don't need anything super secret.
ENV SECRET_KEY_BASE development123

# Add /gems/bin to the path so any installed gem binaries are runnable from bash.
ENV PATH /copec-gems/bin:$PATH

# Setup the directory where we will mount the codebase from the host
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install

# Copy the main application.
COPY . ./

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000