#!/bin/bash

cd /var/www/html/laravel_project

composer install --no-dev --optimize-autoloader

php artisan migrate --force
php artisan config:cache
