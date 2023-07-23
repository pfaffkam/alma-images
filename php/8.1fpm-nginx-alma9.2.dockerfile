# Date should be prefixed with '-'
ARG DATE="" 
FROM pfaffk/php:8.1fpm-alma9.2${DATE}

USER 0

RUN dnf -y install nginx supervisor \
  && dnf -y clean all --enablerepo='*'

# NGINX configuration
RUN sed -i \
      -e 's/^user .*/user www-data;/' \
      -e 's#^pid .*#pid /run/nginx/nginx.pid;#' \
      /etc/nginx/nginx.conf \
  && mkdir -p /run/nginx \
  && chown -R 1000:1000 /var/lib/nginx /var/log/nginx /run/nginx

# SUPERVISOR configuration
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
