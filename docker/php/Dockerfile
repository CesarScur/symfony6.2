FROM php:8.2-fpm

#git
RUN apt-get update  \
    && apt-get install -y git

#pg
RUN apt-get update  \
    && apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

# intl
RUN apt-get -y update \
    && apt-get install -y libicu-dev \
    && docker-php-ext-configure intl

#### Required core extentions
# Possible:
# bcmath bz2 calendar ctype curl dba dl_test dom enchant exif ffi fileinfo filter
# ftp gd gettext gmp hash iconv imap intl json ldap mbstring mysqli oci8 odbc opcache
# pcntl pdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite
# pgsql phar posix pspell readline reflection session shmop simplexml snmp soap
# sockets sodium spl standard sysvmsg sysvsem sysvshm tidy tokenizer xml xmlreader
# xmlwriter xsl zend_test zip
RUN docker-php-ext-install -j$(nproc) \
        intl \
        opcache \
        ctype \
        iconv \
        pgsql \
        pdo \
        pdo_pgsql

# opcache
COPY "docker/php/conf.d/opcache.ini" "/usr/local/etc/php/conf.d/opcache.ini"

#### Required external extentions
# xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug
#    && docker-php-ext-configure xdbeug -dxdebug.start_with_request=yes -dxdebug.discover_client_host=1

# yaml
RUN apt-get update \
    && apt-get install -y libyaml-dev \
    && pecl install yaml \
    && docker-php-ext-enable yaml

# zip
RUN apt-get update \
    && apt-get install -y zip libzip-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

# xsltproc \
RUN apt-get update \
    && apt-get install -y xsltproc

# .ini
RUN cd /usr/local/etc/php/conf.d/ \
    && echo 'memory_limit = 1G' >> /usr/local/etc/php/conf.d/docker-php-ram-limit.ini

COPY --from=composer:2.3 "/usr/bin/composer" "/usr/bin/composer"

RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash \
    && apt-get install symfony-cli

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update && apt-get install -y nodejs build-essential

RUN npm install --global yarn

RUN groupmod -g 1000 www-data
RUN usermod -u 1000 -g 1000 www-data
RUN usermod -a -G root www-data
RUN usermod -d /home/www-data www-data
RUN mkdir /home/www-data
RUN chown www-data:www-data /home/www-data