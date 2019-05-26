#!/usr/bin/env bash

docker-compose up --build --detach && docker system prune --force
