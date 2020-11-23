# ROCKET ELEVATOR DOCKER

So this is my dockerized version of the app. The docker-compose.yml file is contained in the "development"
folder. I used images for the databses, with data persisting in the following :

```ruby
    volumes:
      - db:/var/run/mysqld 
```

```ruby
    volumes:
      - db_data:/var/lib/postgresql/data
```

To pull the docker : docker pull kemtardif/development_web:latest

Once the DockerFile, development/docker-compose and docker ignore file were set up, here's the command I did :

docker-compose build

docker-compose run web rails db:setup

docker-compose rails db:create DB=warehouse => creatre postgres

docker-compose rails db:migrate DB=warehouse => migrate postgres

docker-compose rails dwh:doall => seed postgres

docker-composese up

docker push development_web:latest => to push to DockerHub

-The last three commandes create, migrate and seed the postgres db.
