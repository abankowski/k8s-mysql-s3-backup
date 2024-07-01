FROM alpine:latest

RUN apk upgrade --no-cache && echo https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories &&  apk add --no-cache ca-certificates && apk add --update --no-cache coreutils s3cmd mariadb-client

COPY backup-to-s3.sh /usr/local/bin/
COPY delete-old-files-s3.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/backup-to-s3.sh
RUN chmod +x /usr/local/bin/delete-old-files-s3.sh
