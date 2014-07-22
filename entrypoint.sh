#!/bin/bash
set -e
INITIALIZED_FILE=/etc/postfix/INITIALIZED

if [ ! -f $INITIALIZED_FILE ]; then
                if [[ "x"$MYSQL_HOST == "x" ]]; then
                        export MYSQL_HOST='db'
                fi


                if [[ "x"$MYSQL_USER != "x" && "x"$MYSQL_PASSWORD != "x" && "x"$MYSQL_DATABASE != "x" ]]; then
                        echo >&2 "Parameters detected"

                        export PARAM_MYSQLOK=`mysql -h ${MYSQL_HOST} -u ${MYSQL_USER} --password=${MYSQL_PASSWORD} -e "show databases;"|grep -o "Database"`
                        export PARAM_MYSQLDBOK=`mysql -h ${MYSQL_HOST} -u ${MYSQL_USER} --password=${MYSQL_PASSWORD} -e "show databases;"|grep -o "${MYSQL_DATABASE}"`

                        if [ "$PARAM_MYSQLOK" != "Database" ]; then
                                echo >&2 "Failed to connect to Database"
                                exit 1
                        fi

                        if [[ "$PARAM_MYSQLOK" != "$MYSQL_DATABASE" ]]; then
                                echo >&2 "Initialising DB"
                                sed -i -e "s:\[dbname\]:${MYSQL_DATABASE}:g" /tmp/initdb.sql
								mysql -h $MYSQL_HOST -u $MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_DATABASE < /tmp/initdb.sql

                        fi

                        sed -i -e "s:\[dbhost\]:${MYSQL_HOST}:g" /etc/postfix/mysql-virtual-alias-maps.cf
                        sed -i -e "s:\[dbusername\]:${MYSQL_USER}:g" /etc/postfix/mysql-virtual-alias-maps.cf
                        sed -i -e "s:\[dbpassword\]:${MYSQL_PASSWORD}:g" /etc/postfix/mysql-virtual-alias-maps.cf
                        sed -i -e "s:\[dbname\]:${MYSQL_DATABASE}:g" /etc/postfix/mysql-virtual-alias-maps.cf

                        sed -i -e "s:\[dbhost\]:${MYSQL_HOST}:g" /etc/postfix/mysql-virtual-mailbox-domains.cf
                        sed -i -e "s:\[dbusername\]:${MYSQL_USER}:g" /etc/postfix/mysql-virtual-mailbox-domains.cf
                        sed -i -e "s:\[dbpassword\]:${MYSQL_PASSWORD}:g" /etc/postfix/mysql-virtual-mailbox-domains.cf
                        sed -i -e "s:\[dbname\]:${MYSQL_DATABASE}:g" /etc/postfix/mysql-virtual-mailbox-domains.cf

                        sed -i -e "s:\[dbhost\]:${MYSQL_HOST}:g" /etc/postfix/mysql-virtual-mailbox-maps.cf
                        sed -i -e "s:\[dbusername\]:${MYSQL_USER}:g" /etc/postfix/mysql-virtual-mailbox-maps.cf
                        sed -i -e "s:\[dbpassword\]:${MYSQL_PASSWORD}:g" /etc/postfix/mysql-virtual-mailbox-maps.cf
                        sed -i -e "s:\[dbname\]:${MYSQL_DATABASE}:g" /etc/postfix/mysql-virtual-mailbox-maps.cf                        

						sed -i -e "s:\[dbhost\]:${MYSQL_HOST}:g" /etc/postfix/main.cf
                        sed -i -e "s:\[dbusername\]:${MYSQL_USER}:g" /etc/postfix/main.cf
                        sed -i -e "s:\[dbpassword\]:${MYSQL_PASSWORD}:g" /etc/postfix/main.cf
                        sed -i -e "s:\[dbname\]:${MYSQL_DATABASE}:g" /etc/postfix/main.cf

                        sed -i -e "s:\[dbhost\]:${MYSQL_HOST}:g" /etc/dovecot/dovecot-sql.conf.ext
                        sed -i -e "s:\[dbusername\]:${MYSQL_USER}:g" /etc/dovecot/dovecot-sql.conf.ext
                        sed -i -e "s:\[dbpassword\]:${MYSQL_PASSWORD}:g" /etc/dovecot/dovecot-sql.conf.ext
                        sed -i -e "s:\[dbname\]:${MYSQL_DATABASE}:g" /etc/dovecot/dovecot-sql.conf.ext

                fi

                if [[ "x"$MAIL_HOSTNAME != "x" ]]; then
                        sed -i -e "s:\[primaryhost\]:${MAIL_HOSTNAME}:g" /etc/postfix/main.cf

                        echo >&2 "Setting hostname in config"

                fi

                touch $INITIALIZED_FILE
fi

chown -R vmail:vmail /var/mail 

exec "$@"
