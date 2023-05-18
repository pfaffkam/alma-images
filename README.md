# alma-images
Project that create utility docker images based on AlmaLinux (RedHat binary compatibe distro).

All containes have unified naming convention:
`container-name:containerVersion-systemSystemVersion` - (e.g. `pfaffk/node:16-alma9.2`) - basic image with full system.
`container-name:containerVersion-systemSystemVersion-compileDate` - (e.g. `pfaffk/node:16-alma9.2-20230518`) - basic image with date of creation.

`contianer-name:containerVersion-systemSystem.version-minimal` - (e.g. `pfaffk/node:16-alma9.2-minimal`) - minimal image if available.
`contianer-name:containerVersion-systemSystem.version-minimal-compileDate` - (e.g. `pfaffk/node:16-alma9.2-minimal-20230518`) - minimal image with date of creation
