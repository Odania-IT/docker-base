FROM alpine:3.2
MAINTAINER Mike Petersen <mike@odania-it.de>

# Install base packages
RUN apk update
RUN apk upgrade
RUN apk add curl wget bash htop

# Install ruby and ruby-bundler
RUN apk add ruby ruby-dev ruby-bundler

# Install common dependencies
RUN apk add autoconf zlib openssl imagemagick mariadb-libs libpq sqlite-libs unzip bzip2 libxml2 readline-dev

# Clean APK cache
RUN rm -rf /var/cache/apk/*
