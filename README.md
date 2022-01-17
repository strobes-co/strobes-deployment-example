# Strobes Deployment Tutorial

**About Strobes**

Strobes is a vulnerability management platform that integrates with different vulnerability scanners, threat intel platforms, and DevOps tools to help you in automating and priortising vulnerabilities in a faster yet organized way.

To know more about Strobes: https://strobes.co

Request for a demo or trial: akhil@wesecureapp.com

This sample docker-compose will help you deploy the following services
- The Front End App
- The Rest API
- Celery Worker
- Orchestrator for tasks (Triangulum)
- Nginx
- Rabbitmq
- Postgres
- FluendDB
- Elastic Search

## Current Stable Release

| Service Name  | Version |
| ------------- | ------------- |
| Frontend App | v1.3.3  |
| API  | v2.4.7  |
| Triangulum  | v1.3.0 |

## Deployment

To deploy the product you will be needing a license key, feel free to email us at akhil@wesecureapp.com to request one.

- Clone the repository or download a release from ```https://github.com/strobes-co/strobes-deployment-example/releases```

```
git clone https://github.com/strobes-co/strobes-deployment-example.git
```

- Create a env file  

```
touch api.env
```

- Copy the following content into api.env by replacing required information

```
POSTGRES_DB=strobes
POSTGRES_USER=strobes
POSTGRES_PASSWORD=<replace me>
DEPLOYMENT_MODE=enterprise
DEVELOPMENT=False
DEBUG=False
SECRET_KEY=<replace me>
RABBITMQ_SCHEMA=amqp
RABBITMQ_USERNAME=guest
RABBITMQ_PASSWORD=
RABBITMQ_HOST=rabbitmq
RABBITMQ_PORT=5672
TRIANGULUM_HOST=triangulum
TRIANGULUM_PORT=50051
TRIANGULUM_LOGS_INDEX=triangulum-logs
ARTIFACTS_MOUNT=/artifacts/
AWS_DEFAULT_REGION=<replace me>
AWS_ACCESS_KEY_ID=<replace me>
AWS_SECRET_ACCESS_KEY=<replace me>
AWS_CODE_REPOSITORY=strobes_backend
AWS_DOMAIN=strobes
AWS_ACCOUNT_ID=<replace me>
CELERY_DEBUG=INFO
SMTP_PASSWORD=<replace me>
LICENSE_KEY=<replace me>

```

```
touch triangulum.env
```

- Copy the following content into triangulum.env by replacing required information

```
ORCHESTRATOR=docker
DEVELOPMENT=False
ES_HOST=http://<es-host>:9200/
RABBITMQ_URL=amqp://guest@rabbitmq_tri:5672/
RABBITMQ_HOST=rabbitmq_tri
MOUNT_PATH=/output/
CONTAINER_MOUNT=/output/
ARTIFACTS_MOUNT=/artifacts/
ES_LOGS_INDEX=triangulum-logs
ARTIFACTS_PATH=/artifacts/
SHARED_VOLUME_OUTPUT=triangulum_output
SHARED_VOLUME_ARTIFACTS=triangulum_artifacts
DOCKER_REGISTRY_USERNAME=AWS
DOCKER_REGISTRY_PASSWORD=<replace me>
DOCKER_REGISTRY_HOST=docker.strobes.co
```
  - incase of Orchestrator is ECS
```
ORCHESTRATOR=ECS
PROD_POC=False
DEVELOPMENT=False
ES_HOST=http://<es-host>:9200/
RABBITMQ_URL=amqp://guest@rabbitmq_tri:5672/
RABBITMQ_HOST=rabbitmq_tri
MOUNT_PATH=/efs/output/
CONTAINER_MOUNT=/output/
ARTIFACTS_MOUNT=/artifacts/
ES_LOGS_INDEX=triangulum-logs
ARTIFACTS_PATH=/efs/artifacts/
DOCKER_REGISTRY_USERNAME=AWS
DOCKER_REGISTRY_PASSWORD=<replace_me>
DOCKER_REGISTRY_HOST=docker.strobes.co
AWS_KEY=<replace_me>
AWS_SECRET=<replace_me>
AWS_REGION=ap-south-1
AWS_ECS_CLUSTER=strobes-tasks-cluster
ECS_TASK_SUBNETS=subnet-<replace_me>
ECS_TASK_SECURITY_GROUPS=<replace_me>
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
