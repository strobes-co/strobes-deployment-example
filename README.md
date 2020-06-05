# Strobes Deployment Example

This sample docker-compose will help you deploy the following services
- Strobes React Front App
- Strobes Django API
- Strobes Celery Worker
- Nginx Reverse Proxy for Frontend and Backend
- Rabbitmq
- Postgres

## Deployment

- Clone the repository or download a release from ```https://github.com/strobes-co/strobes-deployment-example/releases```

```
git clone https://github.com/strobes-co/strobes-deployment-example.git
```

- Create a env file  

```
touch .env
```

- Copy the following content into .env by replacing required information

```
DEVELOPMENT=false
SECRET_KEY=<replace_me>
SQL_ENGINE=django.db.backends.postgresql_psycopg2
SQL_HOST=postgres
SQL_PORT=5432
DATABASE=postgres
POSTGRES_DB=strobes
POSTGRES_USER=strobes
POSTGRES_PASSWORD=<replace_me>
DJANGO_SETTINGS_MODULE=strobesAPI.settings
LICENCE_URL=https://<sls_api>
LICENCE_KEY=<license_key>
API_URL=<api_url>
```

- Log into Docker private registry using license key

```
docker login docker.strobes.co
username:AWS
password:<license_key>
```

- Run the services using docker containers

```
docker-compose up -d
```

To check if the services are up go to ```http://localhost```


## Customization

By default the API will running on port ```81``` and frontend on ```80```. To change the you can customize the docker-compose file by
changing

```
  nginx_api:
    image: docker.strobes.co/strobes-nginx:latest
    ports:
      - <port_run_api>:<port_run_api>
    environment:
      - APP_SCHEME=http
      - APP_HOSTNAME=api
      - APP_PORT=8000
      - NGNIX_PORT=<port_run_api>
    depends_on:
      - api

  nginx_fe:
    image: docker.strobes.co/strobes-nginx:latest
    ports:
      - <port_run_fe>:<port_run_fe>
    environment:
      - APP_SCHEME=http
      - APP_HOSTNAME=frontend
      - APP_PORT=3000
      - NGNIX_PORT=<port_run_fe>
    depends_on:
      - frontend
```
