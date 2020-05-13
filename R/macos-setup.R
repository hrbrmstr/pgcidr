#' @name macos_postgresql_setup_with_ip4r
#' @title Setting up macOS PostgreSQL 12 with ip4r extension
#' @description Instructions for setting up PostgreSQL + ipvr + ODBC driver
#'    locally on macOS and using the ODBC driver with the DBI package.
#' @section OS Setup:
#'
#' Get rid of any old, vanilla pg
#'
#' ```shell
#' $ brew uninstall postgresql
#' $ rm -rf /usr/local/var/postgres
#' ```
#'
#' Grab PostgreSQL 12 from The True Source™
#'
#' ```shell
#' $ brew tap petere/postgresql
#' $ brew install petere/postgresql/postgresql@12
#' $ brew install petere/postgresql/postgresql-common
#' ```
#'
#' Initialize the DB and start PG
#'
#' ```shell
#' $ initdb DATA_PATH  -E utf8
#' $ pg_ctl -D /Volumes/otg/postgres -l logfile start
#' ```
#'
#' Make sure it's running
#'
#' ```shell
#' $ ps -ef | grep postgr
#' ```
#'
#' Eyeball the resultant PG config vars
#'
#' ```shell
#' $ pg_config
#' ```
#'
#' Create a user db just b/c
#'
#' ```shell
#' $ createdb ${USER}
#' ```
#'
#' Make sure it worked
#'
#' ```shell
#' $ psql
#' username=# \q
#' ```
#'
#' Get and install ip4r
#'
#' ```shell
#' $ cd /place/where/you/clone/stuff
#' $ git clone git@@github.com:RhodiumToad/ip4r.git
#' $ cd ip4r
#' $ make
#' $ sudo make install
#' ```
#'
#' Get and install PG ODBC
#'
#' ```shell
#' $ cd /place/where/you/clone/stuff
#' $ wget https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-12.01.0000.tar.gz
#' $ tar -xvzf psqlodbc-12.01.0000.tar.gz
#' $ cd psqlodbc-12.01.0000
#' $ ./configure
#' $ make -j 8
#' $ sudo make install
#' $ ls -l /usr/local/lib/psqlodbca.so
#' ```
#'
#' Make a "working" db
#'
#' ```shell
#' $ createdb working
#' ```
#'
#' Add the ip4r extension to the dbs we made
#'
#' ```shell
#' $ psql --command="CREATE EXTENSION ip4r;" working
#' $ psql --command="CREATE EXTENSION ip4r;" ${USER}
#' ```
#'
#' @section macOS DBI PostgreSQL Setup for ^^:
#' ```r
#' DBI::dbConnect(
#'   odbc::odbc(),
#'   driver = "/usr/local/lib/psqlodbca.so",
#'   Database = "working",
#'   Host = "localhost"
#' ) -> con
#' ```
NULL