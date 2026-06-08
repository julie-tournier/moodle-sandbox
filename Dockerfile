FROM php:8.1-apache

# Install required PHP extensions and system packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libpq-dev \
    postgresql-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    intl \
    mysqli \
    pdo \
    pdo_pgsql \
    pgsql \
    opcache \
    zip \
    soap \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite expires headers

# Configure PHP for Moodle
RUN { \
    echo 'max_input_vars = 5000'; \
    echo 'memory_limit = 256M'; \
    echo 'post_max_size = 100M'; \
    echo 'upload_max_filesize = 100M'; \
    echo 'max_execution_time = 300'; \
} > /usr/local/etc/php/conf.d/moodle.ini

# Download and install Moodle
RUN git clone --depth=1 --branch=MOODLE_404_STABLE https://github.com/moodle/moodle.git /var/www/html && \
    mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/html /var/www/moodledata && \
    chmod -R 755 /var/www/moodledata

# Create custom directories
RUN mkdir -p /var/www/html/theme/custom /moodle-config

# Copy scripts
COPY scripts/apply-theme.sh /usr/local/bin/apply-theme.sh
COPY scripts/init-moodle.sh /usr/local/bin/init-moodle.sh
RUN chmod +x /usr/local/bin/apply-theme.sh /usr/local/bin/init-moodle.sh

# Set working directory
WORKDIR /var/www/html

# Use init script as entrypoint
ENTRYPOINT ["/usr/local/bin/init-moodle.sh"]
