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
   Keeping one process in each container is one of fundamential rules of containerization, and we should strive for it whenever it is possible. \
   By placing only one process in container, we can obtain process isolation, better scalability and easier monitoring implementations. \
   Although NGINX is one process (even if we host multiple domains with multiple webpages), splitting into multiple containers can be good idea. Using this approach, we can do isolated builds, deployments and scaling.

5. **Standarized file directory (/www)** \
   In this container we have a symlink (under `\www`) pointing to right default NGINX static files directory with correct access rights (`/usr/share/nginx/html`). You can just copy your files to `/www` directory.
