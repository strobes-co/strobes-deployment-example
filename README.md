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

## Requirements
### Software Requirements:
- Docker
- Docker Compose V2
### Hardware Requirements:
- 32GB Memory
- 4 vCPU
- 100GB Disk space (Recommended)


## Current Stable Release

| Service Name  | Version |
| ------------- | ------------- |
| Frontend App | v3.82.6  |
| API  | v3.90.0  |
| Triangulum  | v5.1.1 |

## Deployment

To deploy the product you will be needing a license key, feel free to email us at akhil@wesecureapp.com to request one.

- Clone the repository ```https://github.com/strobes-co/strobes-deployment-example/releases```

```
git clone https://github.com/strobes-co/strobes-deployment-example.git
```

- Open the api.env file  

```
nano api.env
```

- update the below variables with their appropriate values in api.env

```
POSTGRES_PASSWORD=<replace me>
SECRET_KEY=<replace me>
SMTP_PASSWORD=<replace me>
LICENSE_KEY=<replace me>
```

- Update the below value to True if your environment do not have access to the Internet post deployment

```
AIR_GAPPED_LICENSE=False 
```

- Open the pgbouncer.env

```
nano pgbouncer.env
```

- update the DB_PASSWORD variable with postgres password set in api.env

```
DB_PASSWORD=<replace me>
```

For external file system (optional)
```
S3_BUCKET_NAME=<replace me>
AWS_ACCESS_KEY_ID=<replace me>
AWS_SECRET_ACCESS_KEY=<replace me>
AWS_REGION=<replace me>

```

- Open the triangulum.env file

```
nano triangulum.env
```

- update the below variables with their appropriate values in triangulum.env

```
DOCKER_REGISTRY_PASSWORD=<replace me with license key>
```

- incase of Orchestrator is ECS

```
ORCHESTRATOR=ECS
DOCKER_REGISTRY_PASSWORD=<replace_me>
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

## Staring the services using docker compose

- For Docker Compose V1
```
docker-compose up -d
```

- For Docker Compose V2
```
docker compose up -d
```

To check if the services are up go to ```http://<strobes-deployed-ip>```
