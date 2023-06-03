#!/bin/bash

sudo su

yum install docker -y
systemctl start docker
systemctl enable docker
docker run -dit --name mongo-cont -p 27017:27017 mongo:4.2.24-bionic
docker exec -it mongo-cont /bin/bash
mongo
use CounterDB
db.createCollection("counters")
db.counters.insertOne({"value":0})


