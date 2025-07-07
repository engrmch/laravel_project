#!/bin/bash
# full_cleanup_before_install.sh
# This script performs a comprehensive cleanup of the deployment target directory.

DEPLOYMENT_TARGET_DIR="/var/www/html/laravel_project"

echo "Starting comprehensive cleanup for new deployment in $DEPLOYMENT_TARGET_DIR..."

# Check if the target directory exists
if [ -d "$DEPLOYMENT_TARGET_DIR" ]; then
    echo "Removing all contents from $DEPLOYMENT_TARGET_DIR..."
    # Use shopt -s dotglob to include dotfiles (like .env, .htaccess, etc.)
    shopt -s dotglob
    sudo rm -rf "$DEPLOYMENT_TARGET_DIR"/*
    shopt -u dotglob # Unset dotglob after use

    # You might also want to remove hidden directories separately if dotglob isn't enough
    # for example, if .git or other hidden directories are directly in root.
    # sudo find "$DEPLOYMENT_TARGET_DIR" -maxdepth 1 -type d -name ".*" -exec rm -rf {} +
    # This will remove hidden directories like .git, .vscode, etc.
    # Use with caution: only if you're certain these should be deleted on every deploy.
    # Often, a clean 'rm -rf /*' is enough because the appspec 'files' re-creates the structure.

else
    echo "Deployment target directory $DEPLOYMENT_TARGET_DIR does not exist. Creating it..."
    sudo mkdir -p "$DEPLOYMENT_TARGET_DIR"
    echo "Directory created."
fi

# After clearing, ensure correct ownership and permissions for the base directory
# This is critical before CodeDeploy copies files as the ec2-user/root
# and ensures the web server (apache/www-data) can read them later.
WEB_USER="apache" # Or "www-data" for Ubuntu
echo "Setting ownership of $DEPLOYMENT_TARGET_DIR to ec2-user:$WEB_USER"
sudo chown -R ec2-user:$WEB_USER "$DEPLOYMENT_TARGET_DIR"
echo "Setting permissions of $DEPLOYMENT_TARGET_DIR to 775"
sudo chmod -R 775 "$DEPLOYMENT_TARGET_DIR"


echo "Comprehensive cleanup finished."
