Zabbix Server
-------------

This is a gcavalcante8808/zabbix-server image with Zabbix Server compilled with PostgreSQL support, based on debian docker official image.

Build the Image
---------------

    docker build -t gcavalcante8808/zabbix-server .

If you want to build the image with a specific version of Zabbix (3.2.0 in the sample), you can do the following:

    docker build --build-arg ZBX_VERSION=3.2.0 -t gcavalcante8808/zabbix-server .

Simple Usage
------------

Clone this repository (or copy the docker-compose.yml file) to your computer, and use the ** docker-compose ** to start the services:

``` docker-compose up -d ```

After 15 seconds, check the port 80; the user and password are the default (User: "Admin", Password: "zabbix").

Other infos
-----------

If you don't want to use 'docker-compose', you will need to have a Postgres Database installed and configured with Zabbix Database Creation Scripts already imported.

If you need an Postgres Image configured to operate with Zabbix, you can use my Zabbix Db Image, available at:

https://github.com/gcavalcante8808/docker-zabbix-db-postgres

After the DB configuration, to use this image, you would set the following variables:

 * DB_HOST: Address or the link to the database ('db' is assumed if not provided);
 * DB_PORT: Database Port (5432 is assumed if not provided);
 * DB_USER: Database User ('zabbix' is assumed if not provided);
 * DB_PASS: Database Password ('zabbix' is assumed if not provided);
 * DB_NAME: Database Schema/Name ('zabbix' is assumed if not provided).

Two volumes are available:

 * /usr/local/etc/server.conf.d: which has all zabbix server configuration and allow you to tune your zabbix_server;
 * /usr/local/share/zabbix/externalscripts: Zabbix ExternalScripts dir.

Use the following statement create a new Zabbix Server:

    docker run -d --name zabbix-server -v /conf:/usr/local/etc/zabbix_server.conf.d -v /scripts:/usr/local/share/zabbix/externalscripts -e DB_HOST=192.168.1.100 -e DB_USER=zabbix -e DB_PASS=zabbix -e DB_NAME=zabbix gcavalcante8808/zabbix-server

You can make some server adjustements by create or edit the files inside the "/conf" dir (or the dir what you defined during the run phase).

If you need a frontend to manage your zabbix, you can use my Zabbix FrontEnd Image, available at:

    https://github.com/gcavalcante8808/docker-zabbix-frontend


Author
------

Author: Gabriel Abdalla Cavalcante Silva (gabriel.cavalcante88@gmail.com)
