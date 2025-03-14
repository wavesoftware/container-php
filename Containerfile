FROM docker.io/library/php:8.3-fpm
RUN apt-get update && apt-get upgrade -y && apt-get autoclean

ADD --chmod=0755 \
  https://github.com/mlocati/docker-php-extension-installer/releases/download/2.7.28/install-php-extensions \
  /usr/local/bin/
  
RUN install-php-extensions \
  apcu \
  bcmath \
  curl \
  exif \
  filter \
  gd \
  gettext \
  gmp \
  iconv \
  imagick \
  intl \
  ldap \
  mbstring \
  mcrypt \
  memcached \
  mysqli \
  opcache \
  pcntl \
  pdo \
  pdo_mysql \
  pdo_pgsql \
  pgsql \
  redis \
  sysvsem \
  zip

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
