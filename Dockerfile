# Use official PHP image with Apache
FROM php:8.1-apache

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    && docker-php-ext-install zip pdo pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Update Apache to use Laravel's public folder as the web root
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/public|' /etc/apache2/sites-available/000-default.conf

# Copy app code to container
COPY . /var/www

# Set proper permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

# Install Composer globally
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install PHP dependencies and optimize Laravel
RUN composer install --no-dev --optimize-autoloader \
    && cp .env.example .env

