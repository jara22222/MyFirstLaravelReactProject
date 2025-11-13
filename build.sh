#!/bin/bash
set -e

# Install PHP dependencies
composer install --no-dev --optimize-autoloader --no-interaction

# Install Node.js dependencies
npm ci --no-audit --prefer-offline

# Build assets
npm run build

# Clear caches
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Clean up
npm cache clean --force

# Set permissions
chmod -R 775 storage bootstrap/cache
