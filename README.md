
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-100%25-lightgrey.svg)
[![Linux build
Status](https://travis-ci.org/hrbrmstr/pgcidr.svg?branch=master)](https://travis-ci.org/hrbrmstr/pgcidr)  
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.5.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

# pgcidr

Perform IP Address in CIDR Lookups with PostgreSQL and ip4r

## Description

PostgreSQL has built-in support for IP address and CIDR types but the
ip4r <https://github.com/RhodiumToad/ip4r> extension is much faster.
Tools are provided to create CIDR lookup and IP address source tables
and perform IP address in CIDR queries. Documentation on how to setup
macOS with PostgreSQL and ip4r is also provided.

## What’s Inside The Tin

The following functions are implemented:

  - `create_cidr_lookup_table`: Creates a CIDR lookup table
  - `create_ip_source_table`: Creates a IP address table
  - `find_ips_in_cidrs`: Finds IPs in CIDR blocks
  - `macos_postgresql_setup_with_ip4r`: Setting up macOS PostgreSQL 12
    with ip4r extension

## Installation

``` r
install.packages("pgcidr", repos = c("https://cinc.rud.is", "https://cloud.r-project.org/"))
# or
remotes::install_git("https://git.rud.is/hrbrmstr/pgcidr.git")
# or
remotes::install_git("https://git.sr.ht/~hrbrmstr/pgcidr")
# or
remotes::install_gitlab("hrbrmstr/pgcidr")
# or
remotes::install_bitbucket("hrbrmstr/pgcidr")
# or
remotes::install_github("hrbrmstr/pgcidr")
```

NOTE: To use the ‘remotes’ install options you will need to have the
[{remotes} package](https://github.com/r-lib/remotes) installed.

## Usage

``` r
library(pgcidr)

# current version
packageVersion("pgcidr")
## [1] '0.1.0'
```

``` r
DBI::dbConnect(
  odbc::odbc(),
  driver = "/usr/local/lib/psqlodbca.so",
  Database = "working",
  Host = "localhost"
) -> con

create_cidr_lookup_table(
  pgcon = con,
  tbl_name = "amazon_cidrs",
  drop = TRUE,
  xdf = system.file("extdat", "amzn-cidrs.csv", package = "pgcidr"),
)

create_ip_source_table(
  pgcon = con,
  tbl_name = "weblog",
  drop = TRUE,
  xdf = system.file("extdat", "weblog.csv", package = "pgcidr")
)

find_ips_in_cidrs(
  con, "weblog", "amazon_cidrs"
)

## # A tibble: 83 x 3
##    ip             entity        cidr         
##    <chr>          <chr>         <chr>        
##  1 54.235.230.238 us-east-1     54.234.0.0/15
##  2 54.227.107.78  us-east-1     54.226.0.0/15
##  3 96.127.69.213  us-gov-west-1 96.127.0.0/17
##  4 3.82.223.254   us-east-1     3.80.0.0/12  
##  5 3.83.153.45    us-east-1     3.80.0.0/12  
##  6 54.160.105.136 us-east-1     54.160.0.0/13
##  7 54.225.41.245  us-east-1     54.224.0.0/15
##  8 3.87.18.119    us-east-1     3.80.0.0/12  
##  9 54.91.31.71    us-east-1     54.88.0.0/14 
## 10 54.90.66.13    us-east-1     54.88.0.0/14 
## # … with 73 more rows
```

## pgcidr Metrics

| Lang | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines | (%) |
| :--- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | --: |
| R    |        7 | 0.88 |  75 | 0.72 |          37 | 0.65 |      177 | 0.8 |
| Rmd  |        1 | 0.12 |  29 | 0.28 |          20 | 0.35 |       44 | 0.2 |

## Code of Conduct

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.
