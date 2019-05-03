#For running locally:

`git pull origin master`
`docker-compose up --build --detach && docker rmi $(docker images -a -q)`
