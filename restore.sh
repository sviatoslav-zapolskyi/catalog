#!/usr/bin/env bash

if [ "$1" == "" ] ; then
    echo "provide backup folder name"
else
    BACKUP_HOME=$1

    TAG=$(cat ${BACKUP_HOME}/git_tag.txt)

    git checkout ${TAG}

    echo "stop containers"
    docker stop $(docker ps -a -q)

    echo  "remove all containers"
    docker rm $(docker ps -a -q)

    rm tmp/pids/server.pid

    docker-compose up --build --detach

    read -p 'provide mysql container id: ' MYSQL_CONTAINER

    rm -rf ./storage/
    tar -zxvf ${BACKUP_HOME}/storage.tar.gz

    cat ${BACKUP_HOME}/mysqldump.sql | docker exec -i ${MYSQL_CONTAINER} /usr/bin/mysql -u root -ppassword catalog_development

    echo 'remove old images'
    docker rmi $(docker images -a -q)

    echo 'remove old volumes'
    docker volume rm $(docker volume ls -q)
fi
