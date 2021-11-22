FROM ruby:2.6.5

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get update \
  && apt-get -y install apt-utils \
          build-essential \
          git-core \
          curl libssl-dev \
          libreadline-dev \
          zlib1g zlib1g-dev \
          libcurl4-openssl-dev \
          libxslt-dev libxml2-dev \
          postgresql-11 postgresql-contrib \
          nodejs \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Yarn
RUN apt-get update -q \
  && apt-get install apt-transport-https \
  && wget https://dl.yarnpkg.com/debian/pubkey.gpg -O pubkey.gpg \
  && apt-key add pubkey.gpg \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && apt-get update -q \
  && apt-get install yarn -y \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
  && google-chrome --version

RUN CHROMEDRIVER_VERSION=`wget --no-verbose --output-document - https://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget --no-verbose --output-document /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver && \
    chmod +x /opt/chromedriver/chromedriver && \
    ln -fs /opt/chromedriver/chromedriver /usr/local/bin/chromedriver

# Setup peer trust for postgresql
RUN sed -i 's/md5\|peer/trust/' /etc/postgresql/*/main/pg_hba.conf

# Configure bundler
RUN gem install bundler
RUN bundle config --global path /cache/

# Install and cache node modules
ADD package.json yarn.lock /tmp/yarn/
COPY vendor /tmp/yarn/vendor
RUN cd /tmp/yarn && yarn install
