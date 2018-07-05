FROM debian:stretch

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
    php7.0 \
    php7.0-cli \
    php7.0-curl \
    php7.0-dev \
    php7.0-gd \
    php7.0-intl \
    php7.0-mcrypt \
    php7.0-mysql \
    php7.0-mbstring \
    php7.0-xml \
    php7.0-xsl \
    php7.0-zip \
    php7.0-json \
    php7.0-xdebug \
    php7.0-soap \
    php7.0-bcmath \
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
COPY php/7.0/mods-available/devbox.ini /etc/php/7.0/apache2/conf.d/00-devbox.ini
COPY php/7.0/mods-available/xdebug.ini /etc/php/7.0/apache2/conf.d/90-xdebug.ini
COPY php/7.0/mods-available/devbox.ini /etc/php/7.0/cli/conf.d/00-devbox.ini
COPY php/7.0/mods-available/xdebug.ini /etc/php/7.0/cli/conf.d/90-xdebug.ini

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