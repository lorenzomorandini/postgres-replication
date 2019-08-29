# postgres-replication

Docker image to set up a postgres slave connected with a master

### Build

    docker build . -t morandini/postgres-replication

### Push

    docker push morandini/postgres-replication


## Configure master

* Add the following line to $PGDATA/pg_hba.conf

      host replication $PG_REP_USER 0.0.0.0/0 md5

* Create a new user with replication permission

      CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';

* Add the following lines to $PGDATA/postgresql.conf

      wal_level = hot_standby
      archive_mode = on
      archive_command = 'cd .'
      max_wal_senders = 8
      wal_keep_segments = 8
      hot_standby = on
