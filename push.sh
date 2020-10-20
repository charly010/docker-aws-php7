#!/usr/bin/env bash

docker build -t aws-ami-php7 .
docker login
docker tag aws-ami-php7 charly010/aws-ami-php7
docker push charly010/aws-ami-php7