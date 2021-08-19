#!/usr/bin/env bash

mkdir -p 'storage'
docker-compose up --build --detach && docker system prune --force
