FROM php:8.3-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libonig-dev \
    zlib1g-dev \
    git \
    unzip \
    curl \
    ghostscript \
    libmagickwand-dev \
    libmagickcore-dev \
    && rm -rf /var/lib/apt/lists/*

# Configurar extensión GD
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Instalar extensiones PHP
RUN docker-php-ext-install \
    pdo_mysql \
    mbstring \
    bcmath \
    gd \
    intl \
    zip \
    exif \
    pcntl \
    opcache

# Instalar Imagick vía PECL
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Habilitar lectura de PDFs en ImageMagick (deshabilitado por defecto)
RUN find /etc/ImageMagick* -name "policy.xml" -exec \
    sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/' {} \;

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Habilitar mod_rewrite de Apache
RUN a2enmod rewrite

# Configurar DocumentRoot para Laravel
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Configurar permisos
RUN chown -R www-data:www-data /var/www

WORKDIR /var/www/html