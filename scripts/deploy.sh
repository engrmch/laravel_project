#!/bin/bash

# Navigate to the application's root directory (adjust path if needed)
# The deployment-archive is where CodeDeploy puts your files.
# Assuming files are copied to /var/www/html/your-laravel-app/ as per your appspec.yml's 'destination'
CODEDEPLOY_APP_DIR="/var/www/html/your-laravel-app"
cd $CODEDEPLOY_APP_DIR

echo "Running AfterInstall hooks..."

# Install Composer dependencies
echo "Installing Composer dependencies..."
composer install --no-dev --prefer-dist

# Set correct permissions for storage and cache directories
echo "Setting permissions..."
sudo chown -R www-data:www-data storage bootstrap/cache
sudo chmod -R ug+rwx storage bootstrap/cache

# Generate application key (if .env is not already fully configured)
# Only run if APP_KEY is not already set in .env
if [ -z "$(grep -m 1 '^APP_KEY=' .env)" ]; then
    echo "Generating application key..."
    php artisan key:generate
fi

# Run database migrations
echo "Running database migrations..."
php artisan migrate --force

# Clear caches (optional, but good practice)
echo "Clearing caches..."
php artisan optimize:clear

echo "AfterInstall hooks finished."
