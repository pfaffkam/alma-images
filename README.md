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
- `pfaffk/node:16-alma9.2` - simple container with Node 16.x.x based on AlmaLinux
- `pfaffk/node:16-alma9.2-minimal` - simple container with Node 16.x.x based on AlmaLinux minimal image (microdnf etc.)
