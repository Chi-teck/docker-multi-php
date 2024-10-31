FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt update && apt install -y lsb-release wget && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt purge -y --auto-remove lsb-release wget

RUN apt update && for php_version in 7.3 7.4 8.0 8.1 8.2 8.3; do \
      apt install -y \
      php$php_version \
      php$php_version-fpm \
      php$php_version-apcu \
      php$php_version-bcmath \
      php$php_version-cgi \
      php$php_version-curl \
      php$php_version-igbinary \
      php$php_version-intl \
      php$php_version-gd \
      php$php_version-mbstring \
      php$php_version-sqlite3 \
      php$php_version-xdebug \
      php$php_version-xml \
      php$php_version-zip \
      php$php_version-mysql \
      php$php_version-pgsql; \
    done;

RUN phpdismod xdebug

# Not all extensions are compatible with PHP 8.4 yet.
RUN apt install -y \
    php8.4 \
    php8.4-fpm \
    php8.4-bcmath \
    php8.4-cgi \
    php8.4-curl \
    php8.4-intl \
    php8.4-gd \
    php8.4-mbstring \
    php8.4-sqlite3 \
    php8.4-xml \
    php8.4-zip \
    php8.4-mysql \
    php8.4-pgsql

# Install Composer.
RUN cd /tmp && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    chmod +x composer.phar && mv composer.phar /usr/local/bin/composer

RUN mkdir /var/www
WORKDIR /var/www

CMD ["php"]
