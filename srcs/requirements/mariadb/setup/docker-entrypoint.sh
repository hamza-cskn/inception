#!/bin/bash

mysql_log() {
	local type="$1"
    shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

mysql_note() {
	mysql_log Note "$@"
}

mysql_error() {
	mysql_log ERROR "$@" >&2
	exit 1
}

run_sql() {
    set -- --database=mysql "$@"
    MYSQL_PWD=$MARIADB_ROOT_PASSWORD mariadb -uroot -hlocalhost "$@"
}

temp_server_start() {
	exec /usr/sbin/mariadbd --user=mysql --skip-ssl --pid-file=/tmp/mysql.pid &

	mysql_note "Waiting for server startup"
	local i
	for i in {30..0}; do
		if mariadb -uroot -hlocalhost --database=mysql \
			--skip-ssl --skip-ssl-verify-server-cert \
			<<<'SELECT 1' ; then
			break
		fi
		sleep 1
	done
	if [ "$i" = 0 ]; then
		mysql_error "Unable to start server."
	fi

	declare -g MARIADB_PID
	MARIADB_PID=$(cat /tmp/mysql.pid)
    mysql_note "Server started"
}

temp_server_stop() {
    mysql_note "Stopping temporary MariaDB server. PID: $MARIADB_PID"
	kill "$MARIADB_PID"
	wait "$MARIADB_PID"
}

verify_minimum_env() {
    if [ -n "$MARIADB_PASSWORD" ] && [ -n "$MARIADB_ROOT_PASSWORD" ]; then
        return 0
    else
        mysql_error "MARIADB_PASSWORD and MARIADB_ROOT_PASSWORD must be specified."
    fi
}

init() {
    mysql_note "Initializing database setup process"

	if [ -z "$(ls -A /var/lib/mysql)" ]; then
		mysql_note "/var/lib/mysql is empty, installing MariaDB"
		/usr/bin/mysql_install_db --user=mysql --datadir=/var/lib/mysql
	fi
	
	read MARIADB_ROOT_PASSWORD < /run/secrets/db_root_password
    read MARIADB_PASSWORD < /run/secrets/db_password
    export MARIADB_DATABASE=${MARIADB_DATABASE:-wordpress}
    export MARIADB_USER=${MARIADB_USER:-wordpress}
    verify_minimum_env

	#todo
	echo ROOT_PASSWORD = $MARIADB_ROOT_PASSWORD
	echo PASSWORD = $MARIADB_PASSWORD
	echo DATABASE = $MARIADB_DATABASE
	echo USER = $MARIADB_USER

    mysql_note "Starting temporary MariaDB server"
    temp_server_start

    mysql_note "Creating database ${MARIADB_DATABASE}"
    run_sql <<< "CREATE DATABASE IF NOT EXISTS \`$MARIADB_DATABASE\` ;"
    mysql_note "Granting access to database ${MARIADB_DATABASE} for user ${MARIADB_USER}"
    run_sql <<< "GRANT ALL ON \`$MARIADB_DATABASE\`.* TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD' ;"
    mysql_note "Flushing privileges"
    run_sql <<< "FLUSH PRIVILEGES ;"

    mysql_note "Shutting down temporary MariaDB server"
    temp_server_stop

    mysql_note "Database setup process completed"
}

init

exec $@