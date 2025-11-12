# ============ STAGE 1: Build Frontend (React) ============
FROM node:20-alpine AS frontend

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm ci

# Copy source
COPY . .
# Build React app
RUN npm run build

# ============ STAGE 2: PHP Dependencies ============
FROM composer:2 AS composer

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --prefer-dist --no-scripts

# ============ STAGE 3: Final Image ============
FROM php:8.2-fpm-alpine

# Install system deps (minimal)
RUN apk add --no-cache \
    nginx \
    supervisor \
    libpng libjpeg-turbo freetype \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo_mysql mbstring exif pcntl bcmath gd opcache \
    && rm -rf /var/cache/apk/*

# PHP config
RUN echo "memory_limit=256M" > /usr/local/etc/php/conf.d/memory.ini \
    && echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.max_accelerated_files=10000" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.revalidate_freq=1" >> /usr/local/etc/php/conf.d/opcache.ini \
    && echo "opcache.save_comments=1" >> /usr/local/etc/php/conf.d/opcache.ini

# Copy composer deps
COPY --from=composer /app/vendor /var/www/html/vendor

# Copy app
WORKDIR /var/www/html
COPY . .

# Copy built frontend from stage 1
COPY --from=frontend /app/public/build /var/www/html/public/build

# Remove dev files
RUN rm -rf tests node_modules .git

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Nginx config
COPY docker/nginx.conf /etc/nginx/http.d/default.conf

# Supervisor config
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose port
EXPOSE 80

# Start Supervisor (PHP-FPM + Nginx)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]