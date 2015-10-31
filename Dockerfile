FROM ubuntu:14.04
MAINTAINER Mike Petersen <mike@odania-it.de>

# Set correct environment variables.
ENV HOME /root

# Ruby environment vars
ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.3
ENV RUBY_DOWNLOAD_SHA256 df795f2f99860745a416092a4004b016ccf77e8b82dec956b120f18bdc71edce
ENV RUBYGEMS_VERSION 2.4.8

RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get install -y vim curl nginx bison libgdbm-dev ruby build-essential autoconf zlib1g-dev unzip \
	bzip2 ca-certificates libffi-dev libgdbm3 libssl-dev libyaml-dev procps git vim apt-transport-https \
	supervisor cron unattended-upgrades logcheck logcheck-database make
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

ENV BUNDLER_VERSION 1.10.6

RUN gem install bundler --version "$BUNDLER_VERSION" \
	&& bundle config --global path "$GEM_HOME" \
	&& bundle config --global bin "$GEM_HOME/bin"

# Setup supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup cron
RUN chmod 600 /etc/crontab
COPY cron-supervisor.conf /etc/supervisor/conf.d/cron.conf
COPY 20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades

## Remove useless cron entries.
# Checks for lost+found and scans for mtab.
RUN rm -f /etc/cron.daily/standard
RUN rm -f /etc/cron.daily/upstart
RUN rm -f /etc/cron.daily/dpkg
RUN rm -f /etc/cron.daily/password
RUN rm -f /etc/cron.weekly/fstrim

CMD ["/usr/bin/supervisord"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
