FROM debian:stable-20250224-slim

RUN groupadd -r mysql && useradd -r -g mysql mysql --home-dir /var/lib/mysql
RUN apt update
RUN apt install -y mariadb-server 
RUN mkdir -p /var/lib/mysql /run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld
RUN chmod 1777 /run/mysqld
RUN mkdir -p /etc/mysql/hcoskun.conf.d/ ; echo '!includedir /etc/mysql/hcoskun.conf.d/' >> /etc/mysql/mariadb.cnf
COPY ./setup/docker-entrypoint.sh /home/docker-entrypoint.sh

EXPOSE 3306

VOLUME /var/lib/mysql

ENTRYPOINT [ "/home/docker-entrypoint.sh" ]

CMD [ "/usr/sbin/mariadbd --user=mysql" ]
#CMD [ "bash" ]

