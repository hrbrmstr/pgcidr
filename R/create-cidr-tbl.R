#' Creates a CIDR lookup table
#'
#' The columns named in `entity_col` and `cidr_col` *must exist* in the
#' data frame or CSV file. All `_name`s must be valid PostgreSQL syntax for
#' said names. Setting `drop=TRUE` is _destructive_.\cr
#' \cr
#' NOTE that `cidr_col` is a primary key. Thus duplicate CIDRs are not allowed
#' and it's up to you to ensure that.
#'
#' @param pgcon a PostgreSQL DBI connection
#' @param tbl_name name of the CIDR table (valid PG table name syntax)
#' @param drop drop existing CIDR table if it has the same name? Defaults to `FALSE`.
#' @param xdf Data frame to use to populate the table or a path to a CSV file.
#'        If a path it will be [path.expand()]ed.
#' @param entity_col Name of the column that holds the entity reference name for the CIDR
#' @param cidr_col Name of the column that holds the CIDR block
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
create_cidr_lookup_table <- function(pgcon, tbl_name, drop=FALSE, xdf,
                                     entity_col="entity", cidr_col="cidr") {

  stopifnot(inherits(pgcon, "PostgreSQL"))

  tbl_name <- tbl_name[1]
  idx_name <- ac(gg("{tbl_name}_idx"))

  entity_col <- entity_col[1]
  cidr_col <- cidr_col[1]

  if (inherits(xdf, "character")) {

    tf <- path.expand(xdf[1])
    stopifnot(file.exists(tf))

  } else {

    tf <- tempfile(fileext = ".csv")
    on.exit(unlink(tf))

    xdf <- xdf[,c(entity_col, cidr_col)]
    readr::write_csv(xdf, tf)

  }

  if (drop) {
    dbExecute(pgcon, ac(gg("DROP TABLE IF EXISTS {tbl_name}")))
    dbExecute(pgcon, ac(gg("DROP INDEX IF EXISTS {idx_name}")))
  }

  dbExecute(pgcon, ac(gg("CREATE TABLE {tbl_name}({entity_col} text not null, {cidr_col} ip4r primary key)")))

  dbExecute(pgcon, ac(gg("COPY {tbl_name} FROM '{tf}' WITH (format csv, header)")))
  dbExecute(pgcon, ac(gg("CREATE INDEX {idx_name} ON {tbl_name} USING gist({cidr_col})")))

  invisible(NULL)

}
