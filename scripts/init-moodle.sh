#!/bin/bash
set -e

echo "Starting Moodle initialization..."

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL..."
until PGPASSWORD=$MOODLE_DATABASE_PASSWORD psql -h "$MOODLE_DATABASE_HOST" -U "$MOODLE_DATABASE_USER" -d "$MOODLE_DATABASE_NAME" -c '\q'; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done

echo "PostgreSQL is up"

# Create config.php if it doesn't exist
if [ ! -f /var/www/html/config.php ]; then
    echo "Creating Moodle config.php..."

    cat > /var/www/html/config.php <<EOF
<?php
unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();

\$CFG->dbtype    = '${MOODLE_DATABASE_TYPE}';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = '${MOODLE_DATABASE_HOST}';
\$CFG->dbname    = '${MOODLE_DATABASE_NAME}';
\$CFG->dbuser    = '${MOODLE_DATABASE_USER}';
\$CFG->dbpass    = '${MOODLE_DATABASE_PASSWORD}';
\$CFG->prefix    = 'mdl_';
\$CFG->dboptions = array(
    'dbpersist' => false,
    'dbsocket'  => false,
    'dbport'    => '',
);

\$CFG->wwwroot   = '${MOODLE_SITE_URL}';
\$CFG->dataroot  = '/var/www/moodledata';
\$CFG->directorypermissions = 02777;
\$CFG->admin = 'admin';

require_once(__DIR__ . '/lib/setup.php');
EOF

    chown www-data:www-data /var/www/html/config.php
    chmod 644 /var/www/html/config.php

    echo "config.php created"
fi

# Check if Moodle is already installed
if ! php /var/www/html/admin/cli/check_database_schema.php >/dev/null 2>&1; then
    echo "Installing Moodle..."

    php /var/www/html/admin/cli/install_database.php \
        --agree-license \
        --fullname="${MOODLE_SITE_NAME}" \
        --shortname="Sandbox" \
        --adminuser="${MOODLE_ADMIN_USER}" \
        --adminpass="${MOODLE_ADMIN_PASSWORD}" \
        --adminemail="admin@example.com"

    echo "Moodle installed successfully"
else
    echo "Moodle is already installed"
fi

# Apply theme if specified
if [ -n "$MOODLE_THEME" ] && [ "$MOODLE_THEME" != "boost" ]; then
    echo "Applying theme: $MOODLE_THEME"
    # Set theme via CLI
    php /var/www/html/admin/cli/cfg.php --name=theme --set="$MOODLE_THEME" || true
fi

echo "Moodle initialization complete"

# Start Apache
exec apache2-foreground
