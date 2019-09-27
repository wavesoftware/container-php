FROM php:7-fpm
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libicu-dev \
    libjpeg-dev \
    libldap2-dev \
    libxml2-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libmemcached-dev \
    libpq-dev \
    libzip-dev \
    rsync \
    bzip2 \
    busybox-static \
    libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-configure ldap --with-libdir="lib/$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"
RUN docker-php-ext-install \
    iconv \
    mysqli \
    exif \
    gd \
    intl \
    ldap \
    opcache \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    zip \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    gettext
RUN pecl install APCu-5.1.17
RUN pecl install memcached-3.1.3
RUN pecl install redis-5.0.2
RUN pecl install mcrypt-1.0.3
RUN docker-php-ext-enable \
    apcu \
    memcached \
    redis \
    mcrypt
RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.enable_cli=1'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=10000'; \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.save_comments=1'; \
        echo 'opcache.revalidate_freq=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini && \
    echo 'apc.enable_cli=1' >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    echo 'memory_limit=512M' > /usr/local/etc/php/conf.d/memory-limit.ini
