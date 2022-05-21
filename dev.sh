#!/bin/bash

docker-compose run --rm --service-ports elixir "${*:-bash}"