#!/bin/bash
docker service update --env-add DEMO_VAR=hello my_service
