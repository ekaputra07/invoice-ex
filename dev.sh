#!/bin/bash

docker-compose -f docker-compose.yml run --rm --service-ports app "${*:-bash}"