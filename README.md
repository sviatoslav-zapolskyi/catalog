# For running locally:

### clone repo:

```bash
git clone git@github.com:sviatoslav-zapolskyi/catalog.git
cd catalog
```

### build and run docker containers

```bash
docker-compose up --build --detach
```

### run rails app

```bash
 docker-compose exec app rails s -b 0.0.0.0 -p 3000
```
