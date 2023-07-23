FROM almalinux:9.2-20230718
  
ENV PHP_VERSION=8.1
ARG PACKAGES="php php-bcmath php-gd php-intl php-json php-ldap \
              php-mbstring php-pdo php-soap php-opcache php-xml \
              php-xml php-pecl-zip php-pecl-apcu"

# Install PHP packages from REMI
RUN dnf -y install \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    http://rpms.remirepo.net/enterprise/remi-release-9.rpm \
  && dnf -y module install php:remi-$PHP_VERSION \
  && dnf -y install $PACKAGES

# Create and configure user for PHP 
RUN useradd -u 1000 www-data \
  && sed -i \
       -e 's/^user =.*/user = www-data/' \
       -e 's/^group =.*/group = www-data/' \
       -e 's/^listen =.*/listen = 127.0.0.1:9000' \
       /etc/php-fpm.d/www.conf \
  && rm -rf /var/www/* \
  && chown 1000:1000 /var/www

USER 1000
WORKDIR /var/www

EXPOSE 9000
CMD ["php-fpm"]
