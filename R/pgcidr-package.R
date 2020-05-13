#' Perform IP Address in CIDR Lookups with PostgreSQL
#'
#' PostgreSQL has built-in support for IP address and CIDR types
#' but the ip4r <https://github.com/RhodiumToad/ip4r> extension is much faster.
#' Tools are provided to create CIDR lookup and IP address source tables and
#' perform IP address in CIDR queries. Documentation on how to setup macOS
#' with PostgreSQL and ip4r is also provided.
#'
#' @md
#' @name pgcidr
#' @keywords internal
#' @author Bob Rudis (bob@@rud.is)
#' @importFrom glue glue
#' @importFrom readr write_csv
"_PACKAGE"
