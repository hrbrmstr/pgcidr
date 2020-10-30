#' Creates a IP address table
#'
#' The column named in `ip_col` ` *must exist* in the
#' data frame or CSV file. All `_name`s must be valid PostgreSQL syntax for
#' said names. Setting `drop=TRUE` is _destructive_.
#'
#' @param pgcon a PostgreSQL DBI connection
#' @param tbl_name name of the IP table (valid PG table name syntax)
#' @param drop drop existing IP table if it has the same name? Defaults to `FALSE`.
#' @param xdf Data frame to use to populate the table or a path to a CSV file.
#'        If a path it will be [path.expand()]ed.
#' @param ip_col Name of the column that holds the IP addresses
#' @export
#' @examples \dontrun{
#' DBI::dbConnect(
#'   odbc::odbc(),
#'   driver = "/usr/local/lib/psqlodbca.so",
#'   Database = "working",
#'   Host = "localhost"
#' ) -> con
#'
#' create_cidr_lookup_table(
#'   pgcon = con,
#'   tbl_name = "amazon_cidrs",
#'   drop = TRUE,
#'   xdf = system.file("extdat", "amzn-cidrs.csv", package = "pgcidr"),
#' )
#'
#' create_ip_source_table(
#'   pgcon = con,
#'   tbl_name = "weblog",
#'   drop = TRUE,
#'   xdf = system.file("extdat", "weblog.csv", package = "pgcidr")
#' )
#'
#' find_ips_in_cidrs(
#'   con, "weblog", "amazon_cidrs"
#' )
#'
#' }
create_ip_source_table <- function(pgcon, tbl_name, drop=FALSE, xdf, ip_col = "ip") {

  stopifnot(inherits(pgcon, "PostgreSQL"))

  tbl_name <- tbl_name[1]
  idx_name <- ac(gg("{tbl_name}_idx"))

  ip_col <- ip_col[1]

  if (inherits(xdf, "character")) {

    tf <- path.expand(xdf[1])
    stopifnot(file.exists(tf))

  } else {

    tf <- tempfile(fileext = ".csv")
    on.exit(unlink(tf))

    xdf <- xdf[,c(ip_col)]
    readr::write_csv(xdf, tf)

  }

  if (drop) {

    dbExecute(pgcon, ac(gg("DROP TABLE IF EXISTS {tbl_name}")))
    dbExecute(pgcon, ac(gg("DROP INDEX IF EXISTS {idx_name}")))

  }
  dbExecute(pgcon, ac(gg("CREATE TABLE {tbl_name}({ip_col} ip4 not null)")))

  dbExecute(pgcon, ac(gg("COPY {tbl_name} FROM '{tf}' WITH (format csv, header)")))
  dbExecute(pgcon, ac(gg("CREATE INDEX {idx_name} ON {tbl_name}({ip_col})")))

  invisible(NULL)

}
