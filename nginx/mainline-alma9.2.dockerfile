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
 && chown -R 1000:0 /var/cache/nginx \
                    /var/log/nginx \
                    /etc/nginx/conf.d \
                    /usr/share/nginx \
                    /var/run/nginx.pid \
 && rm /etc/nginx/conf.d/default.conf

USER 1000

CMD ["nginx", "-g", "daemon off;"]
