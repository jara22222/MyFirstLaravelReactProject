# Use PHP 8.2 FPM
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Increase PHP memory limit
RUN echo "memory_limit=1G" > /usr/local/etc/php/conf.d/memory-limit.ini

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy project files
COPY . .

# Install PHP dependencies with memory optimizations
RUN COMPOSER_MEMORY_LIMIT=-1 composer install --no-dev --optimize-autoloader --prefer-dist

# Set Node memory limit to 1GB to prevent OOM
ENV NODE_OPTIONS="--max-old-space-size=1024"

# Install Node dependencies
RUN npm ci --only=production

# Build React app
RUN npm run build

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Expose ports (Laravel & Vite)
EXPOSE 5173  
EXPOSE 8000  

# Use Laravel’s artisan serve or Vite server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
