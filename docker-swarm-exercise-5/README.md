## ⚙️ Exercise 5 - Exercise - Docker Swarm Essentials

This folder demonstrates key Docker Swarm operations using a basic `nginx` service.

## 1. What are the basic commands to manage Docker Swarm?

# Initialize Swarm mode on the manager node

docker swarm init

# Get token to join other nodes as workers

docker swarm join-token worker

# Join a node to the Swarm (run this on the worker node)

docker swarm join --token <worker-token> <manager-ip>:2377

# Deploy a stack using Docker Compose in Swarm mode

docker stack deploy -c docker-compose.yml mystack

# List all nodes in the Swarm

docker node ls

# List all services running in the Swarm

docker service ls

# Inspect a specific service in a user-friendly format

docker service inspect <service_name> --pretty

## 2. How do you find a service in a manager?

# Run on the manager node:

docker node ls # List nodes in the Swarm
docker service ls # List active services

## 3. How do you list a service in a certain host?

# On the specific host:

docker ps # Show containers running on that host

# Or from the manager:

docker service ps <service_name> # Shows tasks and which node they're running on

4. How do you access a container?

docker ps # Get the container ID
docker exec -it <container_id> /bin/sh # Or bash

# For Swarm services:

docker service ps <service_name> # Get the container/task ID
docker exec -it <task_id> /bin/sh

5. How do you retrieve the logs from a container and get the logs live?

# For a single container:

docker logs -f <container_id>

# For a Swarm service:

docker service logs -f <service_name>

6. How do you restart a service in Docker Swarm?

docker service update --force <service_name>

7. How do you update/create an environment variable for a certain service?

docker service update --env-add MY_VAR=value <service_name>

8. How do you scale a service?

docker service scale <service_name>=5 # Note: The default replica count in `docker-compose.yml` is 3, but the command below shows how to override and scale it to 5 at runtime.
