FROM debian:jessie

RUN groupadd zabbix && useradd -g zabbix zabbix && \
    apt-get update && apt-get -y install --no-install-recommends wget tar gcc make postgresql \
    libssh2-1-dev libpq-dev libldap2-dev libiksemel-dev libopenipmi-dev unixodbc-dev libsnmp-dev snmp libpng-dev \ 
    wget libxml2-dev libgnutls28-dev libcurl4-gnutls-dev git nmap fping traceroute curl libldb-dev python-pip && \
    ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get clean

WORKDIR /usr/src
ARG ZBX_VERSION=3.2.0

RUN cd /tmp && git clone https://github.com/meduketto/iksemel.git && \
    cd /usr/src && \
    wget http://ufpr.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/${ZBX_VERSION}/zabbix-${ZBX_VERSION}.tar.gz && \
    tar xzvf zabbix-${ZBX_VERSION}.tar.gz && \
    pip install supervisor && \ 
    cd /usr/src/zabbix-$ZBX_VERSION && \
    ./configure --enable-server --enable-agent --with-postgresql \
    --with-net-snmp --with-libcurl --with-openipmi --with-gnutls \
    --with-ldap --with-libcurl --with-ssh2 --with-unixodbc \
    --with-jabber=/tmp/iksemel --with-libxml2 && make -j && make install -j && \
    mkdir /usr/local/etc/server.conf.d/ && \
    rm -rf /usr/src/zabbix-$ZBX_VERSION 

RUN chown -R zabbix:zabbix /usr/local/etc/zabbix_server.conf.d
EXPOSE 10051

COPY files/zabbix_server.conf /usr/local/etc/zabbix_server.conf
COPY files/docker-entrypoint.sh /
COPY files/supervisord.conf /etc/supervisord.conf

USER zabbix
ENTRYPOINT /docker-entrypoint.sh
