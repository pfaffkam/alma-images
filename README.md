# alma-images
Project that create utility docker images based on AlmaLinux (RedHat binary compatibe distro).

All container images have unified naming convention:
- `container-name` `:` `containerVersion` `-` `system` `system.version` - basic image with full system.
  - `pfaffk/node:16-alma9.2`
 
- `container-name` `:` `containerVersion` `-` `system` `system.version` `-` `compileDate` - basic image with full system and build date.
  - `pfaffk/node:16-alma9.2-20230518`

- `contianer-name` `:` `containerVersion` `-` `system` `system.version` `-` `minimal` - minimal image if available.
  - `pfaffk/node:16-alma9.2-minimal`  
 
- `contianer-name` `:` `containerVersion` `-` `system` `system.version` `-` `minimal` `-` `compileDate` - minimal image with build date.
  - `pfaffk/node:16-alma9.2-minimal-20230518`

### List of 'always up-to-date' images:
| Image & Tag | Software | System | Recommended usage | Maintained | 
|-------------|----------|--------|-------------------|------------|
| `pfaffk/node:16-alma9.2`          | Node (**16**) | Alma 9.2         | React, Vue or other web apps | :hourglass:    | 
| `pfaffk/node:16-alma9.2-minimal`  | Node (**16**) | Alma 9.2 minimal | React, Vue or other web apps | :hourglass:    | 
| `pfaffk/node:18-alma9.2`          | Node (**18**) | Alma 9.2         | React, Vue or other web apps | :green_circle: |
| `pfaffk/node:18-alma9.2-minimal`  | Node (**18**) | Alma 9.2 minimal | React, Vue or other web apps | :green_circle: | 
| | | | |
| `pfaffk/php:8.1fpm-alma-9.2`       | PHP-FPM (**8.1**)         | Alma 9.2 | PHP applications | :green_circle: |
| `pfaffk/php:8.1fpm-nginx-alma-9.2` | PHP-FPM (**8.1**) + NGINX | Alma 9.2 | PHP applications | :green_circle: |

