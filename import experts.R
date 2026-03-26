#  ------------------------------------------------------------------------
#
# Title : IMPORT EXPERTS
#    By :
#  Date : 2026-01-09
#
#  ------------------------------------------------------------------------





library("tidyverse")
library("readODS")
library("labelled")
library("janitor")


# Nombre de feuilles
nsh <- read_ods("datas/validation.ods", sheet = 1, range = "A30", col_names = FALSE)
nsh <- nsh[[1, 1]]
#
range <- c("F10:I23", "J10:M23", "N10:Q23")
#
expsg <- function(sh, i) {
  nna <- c(
    "", " ", "NA", "ND", "#DIV/0", "!", "NC", "Non visible", "NON MESURABLE", "non evaluable",
    "PAS DIMAGES SANS MESURES", "IMPOSSIBLE", "non évaluable", "#DIV/0 !"
  )
  tit <- paste0("exp", i)
  nfg <- c("nf_dt", "gn_dt", "nf_gch", "gn_gch")
  zz <- read_ods("datas/validation.ods", sheet = sh, range = range[i], col_names = TRUE, na = nna) |>
    clean_names() |>
    #  dplyr::filter(nerf_optique_droit!= "zz" | is.na(nerf_optique_droit)) |>
    mutate_all(as.numeric) |>
    pivot_longer(cols = everything(), values_to = tit)
  return(zz)
}
#
tt <- tibble(ll = NULL, exp1 = NULL, exp2 = NULL, exp3 = NULL)

for (sh in 1:nsh) {
  ll <- rep(nfg, 13)
  for (i in 1:3) {
    print(sh)
    zz <- expsg(sh, i)
    ll <- cbind(ll, zz[, 2])
  }
  tt <- rbind(tt, ll)
}
#


save(tt, file = "datas/validation.RData")
load("datas/validation.RData")
