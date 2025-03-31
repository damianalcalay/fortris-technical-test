#!/bin/bash
docker service create --name my_service -p 8080:80 nginx
