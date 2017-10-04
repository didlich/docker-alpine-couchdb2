FROM alpine:3.6

MAINTAINER didlich@t-online.de

# shared directory
RUN mkdir -p /opt/data

# build mozjs
RUN apk add --no-cache --virtual .mozjs-build-deps \
    perl g++ python zip make wget ca-certificates \
  && cd /opt \
  && wget http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz \
  && tar -zxvf js185-1.0.0.tar.gz \
  # patch 
  # https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-lang/spidermonkey/files/spidermonkey-1.8.5-gcc6.patch?id=436f1eed9e302d8b5e0711803f980bc72c81e0d5
  && wget -O spidermonkey-1.8.5-gcc6.patch https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-lang/spidermonkey/files/spidermonkey-1.8.5-gcc6.patch?id=436f1eed9e302d8b5e0711803f980bc72c81e0d5 \
  && cd js-1.8.5 \
  && patch -p1 < ../spidermonkey-1.8.5-gcc6.patch \
  && cd js/src \
  && ./configure --prefix=/usr && make && make install \
  && cd /opt \
  %% rm -r /opt/js-1.8.5 \
  && rm /opt/js185-1.0.0.tar.gz \
  && rm -rf /opt/js-1.8.5 \
  && rm /opt/spidermonkey-1.8.5-gcc6.patch \
  && apk del .mozjs-build-deps \
  && rm -rf /usr/src /var/cache/apk/*

# build couchdb2
RUN apk add --no-cache --virtual .build-deps \
        perl g++ python make icu-dev wget ca-certificates \
        erlang \
        erlang-dev \
        erlang-stdlib \
        erlang-compiler \
        erlang-kernel \
        erlang-crypto \
        erlang-et \
        erlang-ssl \
        erlang-erts \
        erlang-syntax-tools \
        erlang-eunit \
        erlang-reltool \
        erlang-asn1 \
        erlang-tools \
        erlang-inets \
        erlang-os-mon \
        erlang-public-key \
        erlang-runtime-tools \
        erlang-sasl \
        erlang-xmerl \
    && cd /opt \
    && wget http://www-eu.apache.org/dist/couchdb/source/2.1.0/apache-couchdb-2.1.0.tar.gz \
    && tar -zxvf apache-couchdb-2.1.0.tar.gz \
    && cd apache-couchdb-2.1.0 \
    && ./configure --disable-docs \
    && make release \
    && mv rel/couchdb /opt/ \
    && rm -rf /opt/apache-couchdb-2.1.0.tar.gz \
    && rm -rf /opt/apache-couchdb-2.1.0 \
    && apk del .build-deps \
    && rm -rf /usr/lib/node_modules /usr/src/* /var/cache/apk/*
    
RUN apk add --no-cache ncurses icu su-exec \
    && mkdir -p /opt/couchdb/data /opt/couchdb/etc/local.d /opt/couchdb/etc/default.d

# config files from
# https://github.com/klaemo/docker-couchdb/tree/master/2.0.0
COPY local.ini /opt/couchdb/etc/
COPY vm.args /opt/couchdb/etc/

COPY docker-entrypoint.sh /

EXPOSE 5984 4369 9100

VOLUME ["/opt/couchdb/data"]

ENTRYPOINT ["/docker-entrypoint.sh"]

