# ===============================
# Stage 1: Development Environment
# ===============================
FROM php:8.2-fpm-bullseye

# Install system dependencies + PHP extensions + build tools
RUN apt-get update && apt-get install -y \
    git unzip curl zip bash \
    libpng-dev libjpeg-dev zlib1g-dev libfreetype6-dev \
    nodejs npm \
    libonig-dev \
    build-essential python3 \
    && docker-php-ext-install pdo_mysql gd opcache \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Copy Laravel app
COPY . .

# Set permissions
RUN mkdir -p storage/framework/cache/data storage/framework/sessions storage/framework/views \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

# Install Composer dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader --prefer-dist --no-scripts --ignore-platform-reqs

# Install Node dependencies
RUN npm ci --legacy-peer-deps

# Expose ports for Laravel & Vite
EXPOSE 8000 5173

# Start dev environment: Laravel + Vite
CMD bash -c "php artisan serve --host=0.0.0.0 --port=8000 & npm run dev"
