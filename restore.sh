#!/usr/bin/env bash

source check_pv_installed.sh

if [ "$1" == "" ] ; then
    echo 'provide backup folder name'
else
    MYSQL_USER=root
    MYSQL_PASSWORD=password

    BACKUP_HOME=${1%/}

    TAG=$(cat ${BACKUP_HOME}/git_tag.txt)

    git checkout ${TAG}

    echo 'Stop containers'
    docker-compose down --timeout 1

    rm -rf ./storage/
    pv ${BACKUP_HOME}/storage.tar.gz | tar --extract --gzip

    rm tmp/pids/server.pid

    docker-compose up --build --detach

    echo 'Restore mysqldump.sql'
    while ! cat ${BACKUP_HOME}/mysqldump.sql | docker-compose exec --no-TTY db /usr/bin/mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} catalog_development >/dev/null 2>&1 ; do
        echo 'Wait mysql to start ...'
        sleep 3
    done
    echo 'Restore mysqldump.sql ... done.'

    docker-compose up --detach worker
    sleep 1

    echo 'Remove all unused containers, networks, images and volumes.'
    docker system prune --force
fi
