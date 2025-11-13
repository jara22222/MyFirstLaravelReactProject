#!/bin/bash
set -e

# Generate application key if not exists
if [ ! -f .env ]; then
    cp .env.example .env
    php artisan key:generate
fi

# Run database migrations
php artisan migrate --force

# Create storage link
php artisan storage:link

# Start the web server
exec php-fpm
