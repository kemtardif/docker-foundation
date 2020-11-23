# ROCKET ELEVATOR DOCKER

So this is my dockerized version of the app. The docker-compose.yml file is contained in the "development"
folder. 

To pull the docker : docker pull kemtardif/development_web:latest

Once the DockerFile, development/docker-compose and docker ignore file were set up, here's the command I did :

docker-compose build
docker-compose run web rails db:setup
docker-compose rails db:create DB=warehouse
docker-compose rails db:migrate DB=warehouse
docker-compose rails dwh:doall

docker push development_web:latest

-The last three commandes create, migrate and seed the postgres db.
