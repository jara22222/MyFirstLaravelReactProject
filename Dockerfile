# ===============================
# Stage 1: Build React Frontend
# ===============================
FROM node:20-bullseye AS frontend

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --legacy-peer-deps

# Copy source code
COPY . .

# Build React assets
RUN npm run build

# ===============================
# Stage 2: Install Composer dependencies
# ===============================
FROM composer:2 AS composer

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --prefer-dist --no-scripts

# ===============================
# Stage 3: PHP-FPM + Nginx Runtime
# ===============================
FROM php:8.2-fpm-bullseye

# Install system dependencies + PHP extensions
RUN apt-get update && apt-get install -y \
    nginx supervisor git unzip libpng-dev libjpeg-dev zlib1g-dev \
    libfreetype6-dev curl zip bash \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd opcache \
    && rm -rf /var/lib/apt/lists/*

# Set PHP memory limit
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory.ini

# Opcache configuration
RUN { \
    echo "opcache.enable=1"; \
    echo "opcache.memory_consumption=128"; \
    echo "opcache.max_accelerated_files=4000"; \
    echo "opcache.revalidate_freq=0"; \
} > /usr/local/etc/php/conf.d/opcache.ini

# Set working directory
WORKDIR /var/www/html

# Copy Laravel app + vendor
COPY --from=composer /app/vendor /var/www/html/vendor
COPY . .

# Copy React build
COPY --from=frontend /app/public/build /var/www/html/public/build

# Permissions
RUN mkdir -p storage/framework/cache/data storage/framework/sessions storage/framework/views \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Cache Laravel configuration
RUN php artisan config:cache \
 && php artisan route:cache \
 && php artisan view:cache

# Configure PHP-FPM to listen on TCP for nginx
RUN sed -i 's|listen = .*|listen = 0.0.0.0:9000|' /usr/local/etc/php-fpm.d/www.conf

# Copy nginx & supervisord configs
COPY docker/nginx.conf /etc/nginx/sites-available/default
COPY docker/supervisord.conf /etc/supervisord.conf

# Expose port 80 for Render
EXPOSE 80

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
