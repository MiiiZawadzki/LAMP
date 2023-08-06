FROM php:8.2-apache

RUN a2enmod rewrite

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
      procps \
      nano \
      git \
      unzip \
      libicu-dev \
      zlib1g-dev \
      libxml2 \
      libxml2-dev \
      libreadline-dev \
      supervisor \
      cron \
      sudo \
      libzip-dev \
      wget \
      nodejs \
      npm \
      librabbitmq-dev \
    && pecl install amqp \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
      pdo_mysql \
      sockets \
      intl \
      opcache \
      zip \
    && docker-php-ext-enable amqp \
    && rm -rf /tmp/* \
    && rm -rf /var/list/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN docker-php-ext-install pdo mysqli pdo_mysql zip;

COPY sites/000-default.conf /etc/apache2/sites-available/
COPY apache2.conf /etc/apache2/apache2.conf

EXPOSE 5173

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN chmod +x /usr/bin/composer

RUN a2enmod rewrite headers && service apache2 restart

RUN chmod +x /usr/bin/composer
COPY . /var/www

WORKDIR /var/www

