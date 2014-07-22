FROM debian:latest

MAINTAINER Tim Herman <tim@belg.be>

RUN groupadd -r mysql && useradd -r -g mysql mysql
RUN apt-get update && apt-get install -y mysql-server apg

RUN sed -i -e "s/= 127.0.0.1/= 0.0.0.0/g" /etc/mysql/my.cnf

WORKDIR /usr/local/mysql
VOLUME /var/lib/mysql

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql"]
