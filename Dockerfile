FROM alpine:3.9
LABEL Maintainer="Ibragim Abubakarov <ibragim.ai95@gmail.com>" \
      Description="Léger conteneur avec Nginx et PHP-FPM 7.2 basé sur Alpine Linux."

# Install packages
RUN apk --no-cache add \
    curl \
    nginx \
    php7 \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fpm \
    php7-cgi \
    php7-common \
    php7-apc \
    php7-calendar \
    php7-date \
    php7-pcntl \
    php7-libxml \
    php7-pecl-mongodb \
    php7-gd \
    php7-json \
    php7-mcrypt \
    php7-exif \
    php7-fileinfo \
    php7-opcache \
    php7-pdo \
    php7-pdo_mysql \
    php7-zip \
    php7-intl \
    php7-tokenizer \
    php7-mbstring \
    php7-gettext \
    php7-mysqli \
    php7-openssl \
    php7-phar \
    php7-bcmath \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-simplexml \
    php7-session \
    php7-zlib \
    supervisor

# Create webroot directories
RUN mkdir -p -m 777 /opt/src
WORKDIR /opt/src

COPY .docker/config/app.conf /etc/nginx/sites-enabled/
COPY .docker/config/fastcgi_params /etc/nginx/sites-enabled/
COPY .docker/config/fpm-pool.conf /etc/php7/php-fpm.d/docker_custom.conf
COPY .docker/config/php.ini /etc/php7/conf.d/docker_custom.conf

COPY .docker/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY . .

RUN chmod -R 0777 /opt/src/app/cache/ && chmod -R 0777 /opt/src/app/logs/

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
