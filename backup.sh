#!/usr/bin/env bash

TAG=$(git describe --tags)
BACKUP_HOME=backups/${TAG}_$(date +"%s")

mkdir -p ${BACKUP_HOME}
echo ${TAG} > ${BACKUP_HOME}/git_tag.txt
tar -zcvf ${BACKUP_HOME}/storage.tar.gz ./storage/
docker exec catalog_db_1 /usr/bin/mysqldump -u root -ppassword catalog_development > ${BACKUP_HOME}/mysqldump.sql
