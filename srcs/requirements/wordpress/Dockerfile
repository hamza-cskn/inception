FROM debian:stable-20250224-slim

WORKDIR /app

RUN apt update
RUN apt install -y \
    php \
    php-bcmath \
    php-curl \
    php-imagick \
    php-intl \
    php-json \
    php-mbstring \
    php-mysql \
    php-xml \
    php-zip \
    php-fpm \
    curl

RUN mkdir -p /var/www/html && \
    curl https://wordpress.org/latest.tar.gz | tar zx -C /var/www/html && \
    mv /var/www/html/wordpress/* /var/www/html && \
    rm -rf /var/www/html/wordpress && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html 

RUN mkdir -p /usr/log/ && \
    touch /usr/log/www.access.log && \
    chown -R www-data:www-data /usr/log/www.access.log && \
    chmod -R 755 /usr/log/www.access.log

EXPOSE 9000
VOLUME /var/www/html

CMD [ "/usr/sbin/php-fpm8.2", "-F", "-e" ]
