# Use PHP 8.2 FPM
FROM php:8.2-fpm

WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Increase PHP memory limit
RUN echo "memory_limit=1G" > /usr/local/etc/php/conf.d/memory-limit.ini

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy backend files only
COPY composer.json composer.lock ./
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev --optimize-autoloader --prefer-dist

# Copy rest of backend + built frontend
COPY . .

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Expose port for Laravel
EXPOSE 8000

# Run Laravel serverzzzz
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
