/etc/init.d/postfix start
/etc/init.d/dovecot start
/etc/init.d/rsyslog start

service syslog-ng start

/usr/local/bin/supervisord -n
