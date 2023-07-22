# node:18-alma9.2-minimal
FROM almalinux:9.2-minimal-20230718
RUN microdnf module enable -y nodejs:18 \
  && microdnf install -y nodejs tar
