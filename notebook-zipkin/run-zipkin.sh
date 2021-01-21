#!/bin/bash
clear
curl -sSL https://zipkin.io/quickstart.sh | bash -s
java -jar zipkin.jar
