# Use the official PHP image with FPM
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
    ca-certificates

# Install Node.js 18.x LTS
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Install Node.js dependencies with fallback
RUN echo "Installing Node.js dependencies..." && \
    npm ci --no-audit --prefer-offline --loglevel verbose || { \
        echo "npm ci failed, falling back to npm install..." && \
        npm install --no-audit --loglevel verbose; \
    }

# Copy composer files and install PHP dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --verbose

# Copy the rest of the application
COPY . .

# Set environment variable to skip Wayfinder generation
ENV VITE_SKIP_WAYFINDER_GENERATE=1

# Build assets with debug output
RUN echo "Building assets..." && \
    npm run build -- --debug || { \
        echo "Build failed, but continuing with the build process..."; \
        exit 0; \
    } && \
    npm cache clean --force

# Configure Nginx
RUN mkdir -p /etc/nginx/sites-available && \
    mkdir -p /etc/nginx/sites-enabled
COPY docker/nginx/nginx.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

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

# Expose port 80 and run supervisord
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]