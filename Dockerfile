# ========= STAGE 1: Frontend (React) =========
FROM node:20-alpine AS frontend

# Fix: Add zlib if needed (most don't)
# RUN apk add --no-cache zlib-dev

WORKDIR /app
COPY package*.json ./
RUN npm ci --legacy-peer-deps

# Copy source (but DO NOT run build)
COPY . .

# ========= STAGE 2: Composer =========
FROM composer:2 AS composer
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --prefer-dist --no-scripts

# ========= STAGE 3: Final Runtime =========
FROM php:8.2-fpm-alpine

# Install minimal deps
RUN apk add --no-cache \
    nginx supervisor libpng libjpeg-turbo freetype \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j$(nproc) pdo_mysql opcache \
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

# Copy vendor
COPY --from=composer /app/vendor /var/www/html/vendor

# Copy app
WORKDIR /var/www/html
COPY . .

# Copy pre-built React assets
COPY --from=frontend /app/public/build public/build

# Remove dev junk
RUN rm -rf tests node_modules .git .env*

# Permissions
RUN chown -R www-data:www-data /var/www/html \
 && chmod -R 755 storage bootstrap/cache

# Nginx + Supervisor
COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/supervisord.conf /etc/supervisord.conf

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]