# ========= STAGE 3: Final Runtime =========
FROM php:8.2-fpm-alpine

# Install minimal build deps + libraries needed for gd + pdo_mysql
RUN apk add --no-cache \
    nginx supervisor \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    zlib-dev \
    oniguruma-dev \
    bash \
    curl \
    # Build tools for compiling extensions
    autoconf \
    gcc \
    g++ \
    make \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j$(nproc) pdo_mysql opcache gd \
 && rm -rf /var/cache/apk/*

# PHP memory limit
RUN echo "memory_limit=128M" > /usr/local/etc/php/conf.d/memory.ini

# Opcache
RUN { \
    echo "opcache.enable=1"; \
    echo "opcache.memory_consumption=64"; \
    echo "opcache.max_accelerated_files=4000"; \
    echo "opcache.revalidate_freq=0"; \
  } > /usr/local/etc/php/conf.d/opcache.ini
