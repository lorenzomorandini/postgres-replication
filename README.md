# postgres-replication

Docker image to set up a postgres slave connected with a master

### Build

docker build . -t morandini/postgres-replication

### Push

docker push morandini/postgres-replication



## Configure master

Add 'host replication $PG_REP_USER 0.0.0.0/0 md5' to $PGDATA/pg_hba.conf

Create user with 'CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';'

Add 
'
wal_level = hot_standby

archive_mode = on

archive_command = 'cd .'

max_wal_senders = 8

wal_keep_segments = 8

hot_standby = on
'

to $PGDATA/postgresql.conf
