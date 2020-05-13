#' Finds IPs in CIDR blocks
#'
#' After you use [create_cidr_lookup_table()] and [create_ip_source_table()]
#' use this function to do the lookup.
#'
#' @param pgcon a PostgreSQL DBI connection
#' @param ip_tbl name of the IP table (valid PG table name syntax)
#' @param cidr_tbl name of the CIDR table (valid PG table name syntax)
#' @param ip_col Name of the column that holds the IP addresses in `ip_tbl`
#' @param cidr_col Name of the column that holds the CIDR block in `cidr_tbl`
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
find_ips_in_cidrs <- function(pgcon, ip_tbl, cidr_tbl,
                              ip_col = "ip", cidr_col = "cidr") {

  stopifnot(inherits(con, "PostgreSQL"))

  ip_tbl <- ip_tbl[1]
  cidr_tbl <- cidr_tbl[1]
  ip_col <- ip_col[1]
  cidr_col <- cidr_col[1]

  DBI::dbGetQuery(
    con,
    ac(gg("
SELECT
  *
FROM {ip_tbl}, {cidr_tbl} WHERE {ip_col} <<= {cidr_col}
"))
  ) -> res

  if (inherits(res, "data.frame")) {
    class(res) <- c("tbl_df", "tbl", "data.frame")
  }

  res

}
