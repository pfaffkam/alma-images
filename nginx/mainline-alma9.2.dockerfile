FROM almalinux:9.2-20230718

EXPOSE 8080
EXPOSE 8443

LABEL org.opencontainers.image.authors="Kamil Pfaff" \
      org.opencontainers.image.url="" \
      org.opencontainers.image.documentation="https://github.com/Reykez/alma-images/tree/main/nginx/README.md" \
      org.opencontainers.image.source="https://github.com/Reykez/alma-images/tree/main/nginx" \
      org.opencontainers.image.title="NGINX Alma Linux"

COPY nginx.repo /etc/yum.repos.d/nginx.repo

RUN dnf -y install nginx \
 && dnf -y clean all --enablerepo='*'

COPY error_pages/ /usr/share/nginx/error_pages/
COPY nginx.conf /etc/nginx/nginx.conf
COPY error_pages.conf /etc/nginx/conf.d/error_pages.conf

# Drop root user
RUN touch /var/run/nginx.pid \
 && ln -s /usr/share/nginx/html /www \
 && chown -R 1000:0 /usr/share/nginx \
                    /var/cache/nginx \
                    /var/log/nginx \
                    /etc/nginx/conf.d \
                    /var/run/nginx.pid \
 && chmod g+s /usr/share/nginx \
 && chmod -R g+rwX /var/log/nginx \
                   /var/cache/nginx \
 && rm /etc/nginx/conf.d/default.conf

USER 1000:0

CMD ["nginx", "-g", "daemon off;"]
