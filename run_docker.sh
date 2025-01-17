#!/usr/bin/env bash
set -ex

mvn clean package
#mvn native:compile -Pnative

# Multistage build for MacOS, Windows, and Linux
docker build -t meet-graal-vm .

# run docker
docker run -p 8080:8080 meet-graal-vm