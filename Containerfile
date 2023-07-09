FROM docker.io/library/php:8.1-fpm
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
    libgmp-dev \
    rsync \
    bzip2 \
    busybox-static \
    libmagickwand-dev \
    imagemagick
RUN docker-php-ext-configure gd \
  --with-freetype \
  --with-jpeg
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
    gettext \
    bcmath \
    gmp
RUN yes '' | pecl install imagick
RUN yes '' | pecl install apcu
RUN yes '' | pecl install memcached
RUN yes '' | pecl install redis
RUN yes '' | pecl install mcrypt
RUN docker-php-ext-enable \
    apcu \
    memcached \
    redis \
    mcrypt \
    imagick
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
