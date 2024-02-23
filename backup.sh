#!/usr/bin/env bash

source check_pv_installed.sh

TAG=$(git describe --tags)
BACKUP_HOME=backups/${TAG}_$(date +"%s")

mkdir -p "${BACKUP_HOME}"
echo "${TAG}" > "${BACKUP_HOME}/git_tag.txt"
#tar -zcvf "${BACKUP_HOME}/storage.tar.gz" ./storage/
tar cf - ./storage/ -P | pv -s $(($(du -sk ./storage/ | awk '{print $1}') * 1024)) | gzip > "${BACKUP_HOME}/storage.tar.gz"

docker-compose exec db /usr/bin/mysqldump -u root -ppassword catalog_development > "${BACKUP_HOME}/mysqldump.sql"
