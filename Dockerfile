FROM php:7.4-apache

# ä¬ã´ïœêî
ENV DEBCONF_NOWARNINGS yes

RUN apt-get update && apt-get install -y apt-utils apt-transport-https \
      libicu-dev \
      libpq-dev \
      libonig-dev \
      mariadb-client-10.3 \
      git \
      zip \
      unzip \
      libfreetype6-dev \
      libpng-dev \
      libjpeg-dev \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install \
      intl \
      openssl \
      pcntl \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      zip \
      gd

ENV APP_HOME /var/www/html

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

RUN sed -i -e "s/html/html\/webroot/g" /etc/apache2/apache2.conf

RUN a2enmod rewrite

COPY . $APP_HOME

RUN chown -R www-data:www-data $APP_HOME

COPY php.ini /usr/local/etc/php/

