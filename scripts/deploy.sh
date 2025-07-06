#!/bin/bash

cd /var/www/html/laravel_project

# Set permissions
sudo chown -R apache:apache .
sudo chmod -R 775 storage bootstrap/cache

# Laravel setup
composer install --no-dev --optimize-autoloader
php artisan migrate --force
php artisan config:cache
php artisan route:cache

# Restart Apache
sudo systemctl restart httpd
