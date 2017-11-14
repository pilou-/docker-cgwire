#!/bin/bash

[ "$(ls -A /var/lib/postgresql)" ] && echo "Running with existing database in /var/lib/postgresql" || ( echo 'Populate initial db'; cd /; tar xvjf /opt/zou/postgresql.tar.bz2 )

user=$(stat -c '%U' /var/lib/postgresql/9.5)
group=$(stat -c '%G' /var/lib/postgresql/9.5)
if [ "${user}" != "postgres" ] || [ "${group}" != "postgres" ]; then
    echo "/var/lib/postgresql/9.5: update owner and group"
    chown -R postgres:postgres /var/lib/postgresql/9.5
fi

# create /var/run/postgresql
. /usr/share/postgresql-common/init.d-functions
create_socket_directory

echo Running Zou...
supervisord -c /etc/supervisord.conf
