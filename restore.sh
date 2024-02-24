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

    # applying mysqldump.sql through `docker-compose exec` doesn't work
    # Rancher and Docker creates differ container names when `docker-compose up`
    # for make script work for both Rancher and Docker I should up db first and store container id
    docker-compose up --detach db
    DB_ID="$(docker-compose ps --quiet)"

    docker-compose up --build --detach

    echo 'Restore mysqldump.sql'
    while ! cat ${BACKUP_HOME}/mysqldump.sql | docker exec -i "$DB_ID" /usr/bin/mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} catalog_development &>/dev/null ; do
        echo 'Wait mysql to start ...'
        sleep 3
    done
    echo 'Restore mysqldump.sql ... done.'

    docker-compose up --detach worker
    sleep 1

    echo 'Remove all unused containers, networks, images and volumes.'
    docker system prune --force
fi
