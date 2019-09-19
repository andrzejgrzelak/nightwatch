FROM node:10-slim

ENV DISPLAY=:99 DEBIAN_FRONTEND=noninteractive
#install application dependencies
RUN DEBIAN_FRONTEND=noninteractive \
  set -ex \
  && apt-get update -qqy \
  && apt-get -y install \
    xvfb \
    curl

#install google-chrome
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update -qqy \
    && apt-get -y install ${CHROME_VERSION:-google-chrome-stable} \
    && rm /etc/apt/sources.list.d/google-chrome.list \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/


#install firefox
ARG FIREFOX_VERSION=54.0
RUN apt-get update -qqy \
    && apt-get -qqy --no-install-recommends install firefox \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
    && apt-get -y purge firefox \
    && rm -rf /opt/firefox \
    && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
    && rm /tmp/firefox.tar.bz2 \
    && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
    && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox 


#install nightwatch
CMD /bin/bash
