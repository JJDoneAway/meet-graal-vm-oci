#!/usr/bin/env bash
set -ex

mvn clean package
#mvn native:compile -Pnative

# Multistage build for MacOS, Windows, and Linux
docker build -t meet-graal-vm .

docker tag meet-graal-vm:latest fra.ocir.io/frg3cbnte5ex/meet-graal-vm:1

# run docker
docker run -p 8080:8080 meet-graal-vm