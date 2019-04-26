#!/usr/bin/env bash

if [ "$1" == "" ] ; then
    echo "provide mysql container id"
else
    MYSQL_CONTAINER=$1

    BACKUP_HOME=backups/$(date +"%s")
    TAG=$(git describe --tags)

    mkdir -p ${BACKUP_HOME}
    echo ${TAG} > ${BACKUP_HOME}/git_tag.txt
    tar -zcvf ${BACKUP_HOME}/storage.tar.gz ./storage/
    docker exec ${MYSQL_CONTAINER} /usr/bin/mysqldump -u root -ppassword catalog_development > ${BACKUP_HOME}/mysqldump.sql
fi
