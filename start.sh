/etc/init.d/postfix start
/etc/init.d/dovecot start
service syslog-ng start

/usr/local/bin/supervisord -n
