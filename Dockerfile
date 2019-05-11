FROM ubuntu:18.04
MAINTAINER Mike Petersen <mike@odania-it.de>

# Set correct environment variables.
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

RUN apt-get update && apt-get -y dist-upgrade \
	&& apt-get install -y vim curl bison libgdbm-dev ruby build-essential autoconf zlib1g-dev unzip \
		bzip2 ca-certificates libffi-dev libgdbm5 libssl-dev libyaml-dev procps git vim apt-transport-https \
		unattended-upgrades logcheck logcheck-database make htop vim wget zip software-properties-common \
		libxml2-dev libxslt1-dev imagemagick libmagickwand-dev libmysqlclient-dev libsqlite3-dev libpq-dev \
		libcurl4-openssl-dev net-tools libreadline-dev \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Ruby environment vars
ENV RUBY_MAJOR 2.6
ENV RUBY_VERSION 2.6.3
ENV RUBY_DOWNLOAD_SHA256 577fd3795f22b8d91c1d4e6733637b0394d4082db659fccf224c774a2b1c82fb
ENV RUBYGEMS_VERSION 3.0.3

RUN rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/src/ruby \
	&& curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" \
	&& echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.gz" | sha256sum -c - \
	&& tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
	&& rm ruby.tar.gz \
	&& cd /usr/src/ruby \
	&& autoconf \
	&& ./configure --disable-install-doc \
	&& make -j"$(nproc)" \
	&& make install \
	&& apt-get purge -y --auto-remove bison libgdbm-dev ruby \
	&& gem update --system $RUBYGEMS_VERSION \
	&& rm -r /usr/src/ruby

# install things globally, for great justice
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH

ENV BUNDLER_VERSION 2.0.1

RUN gem install bundler --version "$BUNDLER_VERSION" \
	&& bundle config --global path "$GEM_HOME" \
	&& bundle config --global bin "$GEM_HOME/bin"
