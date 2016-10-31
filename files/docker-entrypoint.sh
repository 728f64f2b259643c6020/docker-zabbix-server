#!/bin/bash

set -e

CONF="/usr/local/etc/zabbix_server.conf.d"

if [ -z ${DB_HOST} ]; then
    echo "No Default DB Host Provided. Assuming 'db'"
    DB_HOST="db"
fi

if [ -z ${DB_PORT} ]; then
    echo "No Default port for Db Provided. Assuming 5432."
    DB_PORT=5432
fi

if [ -z ${DB_USER} ]; then
    echo "No Default User provided for Db. Assuming zabbix"
    DB_USER="zabbix"
fi

if [ -z ${DB_PASS} ]; then
    echo "No Default DB Password provided. Assuming zabbix"
    DB_PASS="zabbix"
fi

if [ -z ${DB_NAME} ]; then
    echo "No default db name provided. Assuming zabbix"
    DB_NAME="zabbix"
fi

if [ ! -d "/tmp/firstrun" ]; then
    echo "DBHost=${DB_HOST}" > $CONF/db.conf
    echo "DBPort=${DB_PORT}" >> $CONF/db.conf
    echo "DBUser=${DB_USER}" >> $CONF/db.conf
    echo "DBName=${DB_NAME}" >> $CONF/db.conf
    echo "DBPassword=${DB_PASS}" >> $CONF/db.conf

    echo "LogFile=/tmp/zabbix_server.log" > $CONF/log.conf
    echo "LogFileSize=1024" >> $CONF/log.conf
    echo "LogType=console" >> $CONF/log.conf

    echo "ListenPort=10051" >> $CONF/general.conf
    touch /tmp/firstrun
fi

exec /usr/local/bin/supervisord -c /etc/supervisord.conf
