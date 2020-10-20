#!/usr/bin/env bash

docker build -t aws-php7 .
docker login
docker tag aws-php7 charly010/aws-php7
docker push charly010/aws-php7