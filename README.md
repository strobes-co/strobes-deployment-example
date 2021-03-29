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
| Frontend App | v1.4  |
| API  | v1.4  |
| Triangulum  | v1.3 |

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
POSTGRES_PASSWORD=<replace_me>
DEPLOYMENT_MODE=enterprise
DEVELOPMENT=False
SECRET_KEY=<replace_me>
CONTAINER_URL=http://api:8000
RABBITMQ_USERNAME=guest
RABBITMQ_PASSWORD=
RABBITMQ_HOST=rabbitmq
RABBITMQ_PORT=5672
TRIANGULUM_HOST=triangulum
TRIANGULUM_PORT=50051
TRIANGULUM_LOGS_INDEX=triangulum-logs
ARTIFACTS_MOUNT=/artifacts/
LICENSE_URL=https://license.strobes.co/api/license/validate/
LICENSE_KEY=<license_key>
PROD_POC=False
PROD_POC_INTEL_URL=https://intel.strobes.co
```

```
touch triangulum.env
```

- Copy the following content into triangulum.env by replacing required information

```
ORCHESTRATOR=docker
PROD_POC=False
DEVELOPMENT=False
ES_HOST=http://<es-host>:9200/
DOCKER_REGISTRY_USERNAME=AWS
DOCKER_REGISTRY_PASSWORD=<replace_me>
DOCKER_REGISTRY_HOST=docker.strobes.co
AWS_REGION=ap-south-1
RABBITMQ_URL=amqp://guest@rabbitmq_tri:5672/
MOUNT_PATH=/output/
CONTAINER_MOUNT=/output/
ARTIFACTS_MOUNT=/artifacts/
RABBITMQ_HOST=rabbitmq_tri
ES_LOGS_INDEX=triangulum-logs
ARTIFACTS_PATH=/artifacts/
SHARED_VOLUME_OUTPUT=triangulum_output
SHARED_VOLUME_ARTIFACTS=triangulum_artifacts
AWS_KEY=<replace_me>
AWS_SECRET=<replace_me>
AWS_ECS_CLUSTER=strobes-tasks-cluster
ECS_TASK_SUBNETS=subnet-<replace_me>
ECS_TASK_SECURITY_GROUPS=<replace_me> 
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



