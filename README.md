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

Once the DockerFile, development/docker-compose and docker ignore file were set up, here's the command I did, all in the development folder :

docker-compose build

docker-compose run web rails db:create => Create MSQL database

docker-compose run web rails db:setup => migrate and seed the db

docker-compose run web rails db:create DB=warehouse => creatre postgres

docker-compose run web rails db:migrate DB=warehouse => migrate postgres

docker-compose run web rails dwh:doall => seed postgres

docker-composese up

docker push development_web:latest => to push to DockerHub

