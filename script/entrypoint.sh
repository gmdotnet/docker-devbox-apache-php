#!/usr/bin/env bash

set -e

#############################################
# POSTFIX
#############################################

# POSTFIX_var env -> postconf -e var=$POSTFIX_var
for e in ${!POSTFIX_*} ; do postconf -e "${e:8}=${!e}" ; done

service postfix start

#############################################
# APACHE
#############################################

if [ "$APACHE_USER_UID" != false ]; then
    usermod -u $APACHE_USER_UID www-data
fi

if [ "$APACHE_USER_GID" != false ]; then
    groupmod -g $APACHE_USER_GID www-data
fi

chown www-data:www-data /var/www/ -R

/usr/sbin/apache2ctl -D FOREGROUND
