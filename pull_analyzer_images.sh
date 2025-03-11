#!/bin/sh

# List of Docker images
IMAGES="
docker.strobes.co/analyzers/dependency
docker.strobes.co/analyzers/eslintanalyzer
docker.strobes.co/analyzers/flawfinderanalyzer
docker.strobes.co/analyzers/gitleaksanalyzer
docker.strobes.co/analyzers/gosecanalyzer
docker.strobes.co/analyzers/mobsfscananalyzer
docker.strobes.co/analyzers/nodejsscananalyzer
docker.strobes.co/analyzers/phpcsanalyzer
docker.strobes.co/analyzers/prowleranalyzer
docker.strobes.co/analyzers/prowlerassetinventoryanalyzer
docker.strobes.co/analyzers/pythonexecutoranalyzer
docker.strobes.co/analyzers/reportparser
docker.strobes.co/analyzers/sbomanalyzer
docker.strobes.co/analyzers/scodescan-analyzer
docker.strobes.co/analyzers/semgrepanalyzer
docker.strobes.co/analyzers/sonarqubeanalyzer
docker.strobes.co/analyzers/spotbugsanalyzer
docker.strobes.co/analyzers/strobesdastalphaanalyzer
docker.strobes.co/analyzers/trivyanalyzer
docker.strobes.co/analyzers/zapanalyzer
"

# Loop through each image and pull it
for IMAGE in $IMAGES; do
    echo "Pulling image: $IMAGE"
    docker pull "$IMAGE"
done

echo "All images pulled successfully."