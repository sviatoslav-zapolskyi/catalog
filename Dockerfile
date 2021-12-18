FROM ruby:2.6.8

# http://mozilla.debian.net/
RUN echo "deb http://security.debian.org/ stretch/updates main" > /etc/apt/sources.list.d/debian-mozilla.list \
       && apt-get update \
       && apt-get install -y firefox-esr

RUN VERSION='v0.24.0' \
       && curl -L https://github.com/mozilla/geckodriver/releases/download/${VERSION}/geckodriver-${VERSION}-linux64.tar.gz | tar xz -C /usr/local/bin

# https://github.com/nodesource/distributions#installation-instructions
RUN curl -sL https://deb.nodesource.com/setup_17.x | bash - \
       && apt-get install -y nodejs

# Make the directory for the app
RUN mkdir /app
# Set the working directory of everything to the directory we just made.
WORKDIR /app
# Copy the gemfile and gemfile.lock so we can run bundle on it
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
# Install and run bundle to get the app ready
RUN gem install bundler
RUN bundle install
# Copy the Rails application into place
COPY . .
# Expose port 3000 on the container
EXPOSE 3000
# Run the application on port 3000
CMD rails s -b 0.0.0.0 -p 3000
