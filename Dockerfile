FROM alpine:3.4
MAINTAINER Mike Petersen <mike@odania-it.de>

# Install base packages
RUN apk update
RUN apk upgrade
RUN apk --update add curl wget bash htop curl-dev build-base bind-tools

# Install ruby and ruby-bundler
RUN apk --update add ruby ruby-dev ruby-bundler ruby-io-console ruby-irb ruby-json ruby-rake ruby-rdoc

# Install common dependencies
RUN apk --update add autoconf zlib openssl imagemagick mariadb-dev libpq postgresql-dev sqlite-libs \
			sqlite-dev unzip bzip2 libxml2 readline-dev openssh-client git

# Clean APK cache
RUN rm -rf /var/cache/apk/*
