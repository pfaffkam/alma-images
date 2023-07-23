# PHP images
Docker PHP images based on AlmaLinux and REMI modulas repos. 

In production you shuld use **specific version** instead of 'latests'. 
All images are versioned by suffix with build date in `YYYYMMDD` format. 

## Available images
| Image & Tag | Software | System | Maintained | 
|-------------|----------|--------|------------|
| `pfaffk/php:8.1fpm-alma-9.2`       | PHP-FPM (**8.1**)         | Alma 9.2 | :green_circle: |
| `pfaffk/php:8.1fpm-nginx-alma-9.2` | PHP-FPM (**8.1**) + NGINX | Alma 9.2 | :green_circle: |

## Usage
### Installation of additional PHP packages
To install aditional packages please you can use configured [remi modular repo](https://rpms.remirepo.net/enterprise/8/modular/x86_64/repoview/). \
You can just install required packages using `dnf`. For example: `dnf install php-pgsql`.

### Should I use combined PHP + NGINX image or use two images? 
Generally, the Docker best practices says that one container should handle one process. 
Combined images, such as PHP + NGINX breaks this rule. If you can (especially in k8s) you should use two images,
but it most cases it is much more difficult. This two containers needs to share some files, have communication (using socket or network) and it can be tricky to obtain in some cases.

To configure some small applications faster, you can use combined image. 

### PHP + NGINX configuration example
1. Put your app into default directory (`/var/www`) \
     We will be deploying simple REST API builded on Symfony framework. 
2. Add NGINX configuration file.
     ```
     ! TODO !
     ```
! TODO !

### PHP configuration example
In this case, we configure the same app but using two containers. First only with PHP-FPM process, and second with NGINX.

! TODO ! 
