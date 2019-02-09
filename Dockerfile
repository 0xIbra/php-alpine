FROM alpine:3.6
LABEL Maintainer="Ibragim Abubakarov <ibragim.ai95@gmail.com>" \
      Description="Léger conteneur avec Nginx et PHP-FPM 7.1 basé sur Alpine Linux."

# Install packages
RUN apk --no-cache add \
    curl \
    nginx \
    php7 \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fpm \
    php7-gd \
    php7-json \
    php7-intl \
    php7-mbstring \
    php7-mysqli \
    php7-openssl \
    php7-phar \
    php7-xml \
    php7-xmlreader \
    php7-zlib \
    supervisor

# Create webroot directories
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/docker_custom.conf
COPY config/php.ini /etc/php7/conf.d/docker_custom.conf

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY app/ /var/www/html/

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
