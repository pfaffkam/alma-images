FROM almalinux:9.2-20230718

EXPOSE 80

LABEL org.opencontainers.image.authors="Kamil Pfaff" \
      org.opencontainers.image.url="" \
      org.opencontainers.image.documentation="" \
      org.opencontainers.image.source="" \
      org.opencontainers.image.title="NGINX Alma Linux"

COPY nginx.repo /etc/yum.repos.d/nginx.repo

RUN dnf -y install nginx \
 && dnf -y clean all --enablerepo='*'

COPY nginx.conf /etc/nginx/nginx.conf

# Drop root user
RUN touch /var/run/nginx.pid \
 && ln -s /usr/share/nginx/html /www \
 && chown -R 1000:0 /usr/share/nginx \
                    /var/cache/nginx \
                    /var/log/nginx \
                    /etc/nginx/conf.d \
                    /var/run/nginx.pid \
 && chmod -R g+rwX /var/log/nginx \
                   /var/cache/nginx \
 && rm /etc/nginx/conf.d/default.conf

USER 1000:0

CMD ["nginx", "-g", "daemon off;"]
