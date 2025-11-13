# Stage 1: Build assets
FROM node:20 AS node

WORKDIR /var/www

# Copy package files
COPY package.json package-lock.json ./

# Install Node.js dependencies
RUN npm ci --no-audit --prefer-offline

# Copy the rest of the application
COPY . .

# Build assets
ENV VITE_SKIP_WAYFINDER_GENERATE=1
RUN npm run build

# Stage 2: Build the application
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    supervisor \
    gnupg2 \
    ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy application files
COPY --chown=www-data:www-data . .

# Copy built assets from node stage
COPY --from=node --chown=www-data:www-data /var/www/public/build ./public/build

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Configure Nginx
RUN mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled && \
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
COPY docker/nginx/nginx.conf /etc/nginx/sites-available/default

# Configure supervisor
RUN mkdir -p /var/log/supervisor
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache && \
    chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Generate application key if not exists
RUN if [ ! -f .env ]; then \
        cp .env.example .env && \
        php artisan key:generate; \
    fi

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost/health || exit 1

# Expose port 80 and run supervisord
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]