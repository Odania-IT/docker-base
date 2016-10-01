FROM alpine:3.4
MAINTAINER Mike Petersen <mike@odania-it.de>

# Install base packages
RUN apk update
RUN apk upgrade
RUN apk --update add curl wget bash htop curl-dev build-base

# Install ruby and ruby-bundler
RUN apk --update add ruby ruby-dev ruby-bundler ruby-io-console ruby-irb ruby-json ruby-rake ruby-rdoc

# Install common dependencies
RUN apk --update add autoconf zlib openssl imagemagick mariadb-libs libpq sqlite-libs unzip bzip2 libxml2 readline-dev

# Clean APK cache
RUN rm -rf /var/cache/apk/*
