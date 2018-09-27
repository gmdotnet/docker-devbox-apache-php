FROM debian:jessie

MAINTAINER Giuseppe Morelli <info@giuseppemorelli.net>

VOLUME /var/www/
VOLUME /etc/apache2/sites-enabled/

ENV APACHE_USER_UID     33
ENV APACHE_USER_GID     33
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update \
    && apt-get -y install \
    git \
    apache2 \
    php5 \
    php5-cli \
    php5-curl \
    php5-dev \
    php5-gd \
    php5-intl \
    php5-mcrypt \
    php5-mysql \
    php5-xsl \
    php-pclzip \
    php5-json \
    php5-xdebug \
    php5-redis \
    php-soap \
    php-pear \
    postfix \
    wget \
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
COPY php/apache2/mods-available/devbox.ini /etc/php5/apache2/conf.d/00-devbox.ini
COPY php/apache2/mods-available/xdebug.ini /etc/php5/apache2/conf.d/90-xdebug.ini
COPY php/apache2/mods-available/devbox.ini /etc/php5/cli/conf.d/00-devbox.ini
COPY php/apache2/mods-available/xdebug.ini /etc/php5/cli/conf.d/90-xdebug.ini

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