#!/bin/bash

cd /var/www/html/laravel_project

composer install --no-dev --optimize-autoloader

php artisan migrate --force

sudo chown -R apache:apache storage bootstrap/cache
sudo chmod -R 775 storage bootstrap/cache

php artisan config:cache
php artisan route:cache

sudo systemctl restart httpd
