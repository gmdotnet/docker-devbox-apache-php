FROM debian:buster

MAINTAINER Giuseppe Morelli <info@giuseppemorelli.net>

VOLUME /var/www/
VOLUME /etc/apache2/sites-enabled/

ENV APACHE_USER_UID     33
ENV APACHE_USER_GID     33
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update \
    && apt-get -y install \
    apache2 \
    git \
    php7.3 \
    php7.3-common \
    php7.3-cli \
    php7.3-curl \
    php7.3-dev \
    php7.3-gd \
    php7.3-intl \
    php7.3-mysql \
    php7.3-mbstring \
    php7.3-xml \
    php7.3-xsl \
    php7.3-zip \
    php7.3-json \
    php7.3-xdebug \
    php7.3-soap \
    php7.3-bcmath \
    postfix \
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
COPY php/7.3/mods-available/devbox.ini /etc/php/7.3/apache2/conf.d/00-devbox.ini
COPY php/7.3/mods-available/xdebug.ini /etc/php/7.3/apache2/conf.d/90-xdebug.ini
COPY php/7.3/mods-available/devbox.ini /etc/php/7.3/cli/conf.d/00-devbox.ini
COPY php/7.3/mods-available/xdebug.ini /etc/php/7.3/cli/conf.d/90-xdebug.ini

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
