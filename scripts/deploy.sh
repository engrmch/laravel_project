#!/bin/bash
set -e  # stop on first error

cd /var/www/html/laravel_project

echo "Running composer install..."
composer install --no-dev --optimize-autoloader

echo "Setting permissions..."
chmod -R 775 storage bootstrap/cache
chown -R apache:apache .

echo "Running Laravel commands..."
php artisan config:clear
php artisan config:cache
php artisan migrate --force
