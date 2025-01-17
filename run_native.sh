#!/usr/bin/env bash
set -ex

mvn clean package
mvn native:compile -Pnative

./target/meetgraalvm