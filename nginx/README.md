# NGINX image

## Tags
All available images can be view and downloaded from this [dockerhub repository](https://hub.docker.com/repository/docker/pfaffk/nginx/general). 


`pfaffk/nginx:mainline-alma9.2` - always up-to-date image.

## Best practices 
Before you start getting upset that 'something is not working properly', please read this section carefully. It will save you a lot of potential problems.

1. **Specify the image version precisely** \
   While you can use 'always up to date' (constantly changing) image in your drafts, never use that images as a base for production, fail-proof builds. Automatic updates is a benefit, but it does not guarantee that there's no breaking changes between newer versions. \
   When using this image, use tag with date (e.g. `pfaffk/nginx:mainline-alma9.2-20230916`). This tag should refer to the exactly same image, and will not be changed.
2. **Set permissions to group, and ownership to 0 GID** \
   For compatibility with OpenShift security standards, this container uses non-root user with 0 (root) group. \
   All files that application might need to use is owned by this (0) group, and have appropriate group permission. 
   When you will add some new files to container (static website content, configuratiosn etc.) change it ownership to `1000:0` and *set permissions for the group, not for the user*. 
3. **Use non-privileged ports (8080 and 8443)** \
   As discussed in previous step, we trying to keep out of the box compatibility with OpenShift. Non-privileged (standard) containers are run with random (always non-zero/non-root) UID, that prevent us to use any of restricted ports (0-1024). We're recommending to use `8080` for HTTP and `8443` for HTTPS communications by default, and mapping these ports using docker when communication with outside world is required.
4. **One container, one service, one process** \
   Keeping one process in each container is one of fundamential rules of containerization, and we should .strive for it whenever it is possible. \
   By placing only one process in container, we can obtain process isolation, better scalability and easier monitoring implementations. \
   Although NGINX is one process (even if we host multiple domains with multiple webpages), splitting into multiple containers can be good idea. Using this approach, we can do isolated builds, deployments and scaling.
5. **Standardized file directory (/www)** \
   In this container we have a symlink (under `\www`) pointing to right default NGINX static files directory with correct access rights (`/usr/share/nginx/html`). You can just copy your files to `/www` directory.

## Using HTTPS (simplest way)
This image is configured to communicate on 8080 HTTP out of the box, but there's built-in configurations you can enable to support 8443 HTTPS communications. You need only to remove HTTP config and rename HTTPS config.
```docker
FROM pfaffk/nginx:mainline-alma9.2

# Enable HTTPS static file serving
RUN rm /etc/nginx/conf.d/default-http.conf \
 && mv /etc/nginx/conf.d/default-https.conf.disabled /etc/nginx/conf.d/default.conf
 
# Copy static files
COPY dist/ /www/
```

Now NGINX will try to use self-signed dummy certificates. You should never use them! Mount your certificate files:
- `/etc/nginx/ssl/fullchain.pem` - certificate
- `/etc/nginx/ssl/privkey.pem` - private key (certificate key)

For example, mount it when running container by `docker run` command: \
`docker run -itd --name your-app -p 80:8080 -p 443:8443 -v /srv/your-app/ssl:/etc/nginx/ssl your-app:latest`

Where my `fullchain.pem` and `privkey.pem` files are in `/srv/your-app/ssl` host directory.

## Creating Proxies 
This image can be used as well to build NGINX proxies.

Here's the example of using this image as reverse proxy with SSL termination for multiple docker containers.

In this case, image is launched using docker compose.
The `./servers` host directory is mounted under `/etc/nginx/conf.d`. Please keep in mind, when you mount some directories - all directory content is overriden. This means, the `default-http.conf` file that is present by default in `/etc/nginx/conf.d` directory will be deleted. You should put copy of this file inside your host `./servers` directory.

**Due to rootless image policy** (*look at 'Best Pracitices' section, second point*)**, the `./servers` directory should be owned by `root` group, and have group read permission (at least `g=r`).**
```yaml
# docker-compose.yml
---
version: '3.7'

services:
   nginx:
      image: pfaffk/nginx:mainline-alma9.2-20231009
      container_name: lb-nginx
      ports:
        - 80:8080
        - 443:8443
      volumes:
        - ./servers:/etc/nginx/conf.d
```

Next, create file for each service.

```nginx
server {
   listen 8080;
   server_name example.com;

   location / {
         return 301 https://$host$request_uri;
   }

   include includes/custom-error-pages;
}

server {
   listen 8443 ssl;
   server_name example.com;

   ssl_certificate /etc/certs/example.com/fullchain.pem;
   ssl_certificate_key /etc/certs/example.com/privkey.pem;

   include includes/ssl-settings;

   add_header Content-Security-Policy 'upgrade-insecure-requests';

   charset utf-8;

   # Default resolver for Docker. Refresh each 30 seconds.
   resolver 127.0.0.11 valid=30s;   

   location / {
      # Hacky method to prevent NGINX from crashes when upstream is not found.
      set $upstream http://example-app.example-net:80;

      proxy_pass $upstream;
   }

   include includes/custom-error-pages;
   error_log /var/log/nginx/example.com-error.log
   access_log /var/log/nginx/example.com-access.log
}
```

Now you can run your load balancer's docker compose, and everything should works fine.
