#!/bin/bash
set -eo pipefail
shopt -s nullglob

# if command starts with an option, prepend sqlservr
if [ "${1:0:1}" = '-' ]; then
    set -- sqlservr "$@"
fi

# skip setup if they want an option that stops sqlservr
wantHelp=
for arg; do
    case "$arg" in
        -'?'|--help|--print-defaults|-V|--version)
            wantHelp=1
            break
            ;;
    esac
done

# usage: process_init_file FILENAME MSSQLCOMMAND...
#    ie: process_init_file foo.sh sqlcmd -U SA
# (process a single initializer file, based on its extension. we define this
# function here, so that initializer scripts (*.sh) can use the same logic,
# potentially recursively, or override the logic used in subsequent calls)
process_init_file() {
    local f="$1"; shift
    local mssqlcmd=( "$@" )

    case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *.sql)    echo "$0: running $f"; "${mssqlcmd[@]}" -i "$f"; echo ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
}

if [ "$1" = 'sqlservr' -a -z "$wantHelp" ]; then
    if [ ! -s "$MSSQL_VOLUME_PATH/MSSQL_VERSION" ]; then

        echo 'Initializing database'
        /opt/mssql/bin/sqlservr --setup
        /opt/mssql/bin/mssql-conf set sqlagent.enabled false > /dev/null
        echo 'Database initialized'

        $@ > /dev/null &
        pid="$!"

        # wait for sql server to come up
        mssqlcmd=( sqlcmd -S localhost -U SA -P $MSSQL_SA_PASSWORD )
        for i in {30..0}; do
            if "${mssqlcmd[@]}" -b -Q 'SELECT @@VERSION' &> /dev/null; then
                break
            fi
            echo 'MSSQL init process in progress...'
            sleep 1
        done

        echo
        if [ "$MSSQL_DATABASE_NAME" ]; then
            "${mssqlcmd[@]}" -b -Q "CREATE DATABASE $MSSQL_DATABASE_NAME;"
        fi

        echo
        ls /docker-entrypoint-initdb.d/ > /dev/null
        for f in /docker-entrypoint-initdb.d/*; do
            process_init_file "$f" "${mssqlcmd[@]}"
        done

        if ! kill -s TERM "$pid" || ! wait "$pid"; then
            echo >&2 'MSSQL init process failed.'
            exit 1
        fi

        echo
        echo 'MSSQL init process done. Ready for start up.'
        echo $MSSQL_SERVER_VERSION > $MSSQL_VOLUME_PATH/MSSQL_VERSION
        echo
    fi
fi

exec "$@"
