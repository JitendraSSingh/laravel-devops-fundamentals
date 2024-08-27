#!/bin/bash

ID=$(docker ps --filter "ancestor=api:0.1" --format "{{.ID}}")
docker cp $ID:/usr/src/vendor ./api