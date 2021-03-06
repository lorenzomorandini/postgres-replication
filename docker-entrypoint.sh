#!/bin/sh

if [ ! -f "$PGDATA/PG_VERSION" ]; then  # if needed otherwise "pg_basebackup" will throw an error that directory is not empty
    echo "*:*:*:$PG_REP_USER:$PG_REP_PASSWORD" > ~/.pgpass
    chmod 0600 ~/.pgpass
    until ping -c 1 -W 1 ${PG_MASTER_HOST}
    do
        echo "Waiting for master to ping..."
        sleep 1s
    done
    until pg_basebackup -h ${PG_MASTER_HOST} -p ${PG_MASTER_PORT} -D ${PGDATA} -U ${PG_REP_USER} -vP -W
    do
        echo "Waiting for master to connect..."
        sleep 1s
    done

    echo "host replication $PG_REP_USER 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
    set -e

    cat > ${PGDATA}/recovery.conf <<EOF
standby_mode = on
primary_conninfo = 'host=${PG_MASTER_HOST} port=${PG_MASTER_PORT} user=${PG_REP_USER} password=${PG_REP_PASSWORD}'
trigger_file = '/tmp/touch_me_to_promote_to_me_master'
EOF

    # enable replication slots
    if [ -n "${PG_MASTER_SLOT}" ]; then
        echo "primary_slot_name = $PG_MASTER_SLOT" >> "$PGDATA/recovery.conf"
    fi
    chown postgres. ${PGDATA} -R
    chmod 700 ${PGDATA} -R
fi

sed -i 's/wal_level = hot_standby/wal_level = replica/g' ${PGDATA}/postgresql.conf
exec "$@"
