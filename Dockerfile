# install on debian 9 for problems with lib dependency like libcurl3 (not installable on debian 10 -> we have libcurl4)
FROM debian:stretch

MAINTAINER Giuseppe Morelli <info@giuseppemorelli.net>

VOLUME /var/www/
VOLUME /etc/apache2/sites-enabled/

ENV APACHE_USER_UID     33
ENV APACHE_USER_GID     33
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update \
    && apt-get -y install \
    apt-transport-https \
    ca-certificates \
    wget

RUN wget -O "/etc/apt/trusted.gpg.d/php.gpg" "https://packages.sury.org/php/apt.gpg" \
    && sh -c 'echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list'

RUN apt-get update \
    && apt-get -y install \
    apache2 \
    git \
    php7.4 \
    php7.4-common \
    php7.4-cli \
    php7.4-curl \
    php7.4-dev \
    php7.4-gd \
    php7.4-intl \
    php7.4-mysql \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-xsl \
    php7.4-zip \
    php7.4-json \
    php7.4-xdebug \
    php7.4-soap \
    php7.4-bcmath \
    php7.4-imagick	\
    php7.4-exif	\
    php7.4-opcache	\
    php7.4-bcmath \
    php7.4-ctype \
    php7.4-dom \
    php7.4-iconv \
    php7.4-sockets \
    postfix \
    rsync \
    unzip \
    && apt-get clean \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base

COPY script /opt/script/
COPY apache2/conf-enabled/* /etc/apache2/conf-enabled/
COPY apache2/sites-enabled/* /etc/apache2/sites-enabled/
COPY php/7.4/mods-available/devbox.ini /etc/php/7.4/apache2/conf.d/00-devbox.ini
COPY php/7.4/mods-available/xdebug-3.ini /etc/php/7.4/apache2/conf.d/90-xdebug-3.ini
COPY php/7.4/mods-available/devbox.ini /etc/php/7.4/cli/conf.d/00-devbox.ini
COPY php/7.4/mods-available/xdebug-3.ini /etc/php/7.4/cli/conf.d/90-xdebug-3.ini

RUN a2enmod rewrite \
    && a2enmod vhost_alias \
    && a2enmod ssl

ENV \
  POSTFIX_myhostname=hostname \
  POSTFIX_mydestination=localhost \
  POSTFIX_mynetworks=0.0.0.0/0 \
  POSTFIX_relayhost=''

EXPOSE 80
EXPOSE 443
CMD ["/opt/script/entrypoint.sh"]
