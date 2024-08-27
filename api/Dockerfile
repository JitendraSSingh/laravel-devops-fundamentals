FROM php:8.2-fpm AS api

WORKDIR /usr/src

ARG user
ARG uid

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    git \
    curl \
    zip \
    unzip \
    supervisor \
    default-mysql-client \
    procps \
    nano

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

RUN pecl install redis

COPY --from=composer:2.5.8 /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data -u $uid -d /home/$user $user

COPY ./api .

RUN composer install

COPY ./deployment/config/php-fpm/php.ini /usr/local/etc/php/conf.d
COPY ./deployment/config/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /home/app/.composer && \
    chown -R app:app /home/app && \
    chown -R app:app /usr/src


FROM api AS worker
COPY ./deployment/config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisor.conf
CMD ["/bin/sh", "-c", "supervisord -c /etc/supervisor/conf.d/supervisor.conf"]

FROM api AS scheduler
CMD ["/bin/sh", "-c", "nice -n 10 sleep 60 && php /usr/src/artisan schedule:run --verbose --no-interaction"]

USER $user