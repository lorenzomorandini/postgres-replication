# postgres-replication

Two different docker images (master, slave) to set up a postgresql replica cluster

## Build

docker build ./master -t morandini/postgres-replication:master

docker build ./slave -t morandini/postgres-replication:slave

## Push

docker push morandini/postgres-replication:master

docker push morandini/postgres-replication:slave
