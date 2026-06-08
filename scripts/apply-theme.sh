#!/bin/bash
set -e

THEME_NAME=${1:-default}
CONFIG_DIR="/moodle-config"

echo "Applying theme: $THEME_NAME"

# Wait for Moodle to be ready
while [ ! -f /var/www/html/config.php ]; do
    echo "Waiting for Moodle to initialize..."
    sleep 5
done

# Apply theme configuration if exists
if [ -f "$CONFIG_DIR/$THEME_NAME.php" ]; then
    echo "Applying theme configuration from $CONFIG_DIR/$THEME_NAME.php"
    php -r "include '/var/www/html/config.php'; include '$CONFIG_DIR/$THEME_NAME.php';"
fi

echo "Theme $THEME_NAME applied successfully"
