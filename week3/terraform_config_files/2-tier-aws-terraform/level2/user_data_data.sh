#!/bin/bash

yum install docker -y

systemctl start docker

systemctl enable docker

docker run -dit --name mongo-cont -p 27017:27017 mongo:4.2.24-bionic

docker exec -it mongo-cont /bin/bash

mongo

