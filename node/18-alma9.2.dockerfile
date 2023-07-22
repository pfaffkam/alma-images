# node:18-alma9.2
FROM almalinux:9.2-20230718
RUN dnf module enable -y nodejs:18 \
  && dnf install -y nodejs