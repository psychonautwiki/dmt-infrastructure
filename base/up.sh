#!/bin/bash

docker-compose up -d --remove-orphans --scale mediawiki-hhvm=18 --scale h2o=8
