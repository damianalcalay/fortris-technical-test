#!/bin/bash
REPLICAS=$1
docker service scale my_service=$REPLICAS
