#  ------------------------------------------------------------------------
#
# Title : Import validation des lecteurs
#    By : PhM
#  Date : 2025-10-23
#
#  ------------------------------------------------------------------------

library("tidyverse")
library("readODS")
library("labelled")


# Nombre de feuilles
nsh <- read_ods("datas/validation.ods", sheet = 1, range = "A30", col_names = FALSE)
nsh <- nsh[[1, 1]]

#
import_val <- function(sh) {
  nna <- c(
    "", " ", "NA", "ND", "#DIV/0", "!", "NC", "Non visible", "NON MESURABLE", "non evaluable",
    "PAS DIMAGES SANS MESURES", "IMPOSSIBLE", "non évaluable", "#DIV/0 !"
  )
  nom <- read_ods("datas/validation.ods", sheet = sh, range = "C4:C5", col_names = FALSE)
  print(nom)
  lect <- read_ods("datas/validation.ods", sheet = sh, range = "B11:E23", col_names = FALSE, na = nna) |>
    dplyr::filter(...1 != "zz" | is.na(...1)) |>
    mutate_all(as.numeric)
  exp <- read_ods("datas/validation.ods", sheet = sh, range = "R11:U23", col_names = FALSE, na = nna) |>
    dplyr::filter(...1 != "zz" | is.na(...1)) |>
    mutate_all(as.numeric)
  dif <- abs(exp - lect)
  names(lect) <- paste0("lect", 1:4)
  names(dif)[1:4] <- c("nf_dt", "gn_dt", "nf_gch", "gn_gch")
  #
  nf <- c(dif$nf_dt, dif$nf_gch)
  gn <- c(dif$gn_dt, dif$gn_gch)
  nom <- rep(paste0(nom[1, 1], " (c", nom[2, 1], ")"), length(nf))
  ll <- tibble(nom = nom, nerf = nf, gaine = gn)
}
#
val <- NULL
for (sh in 1:nsh) {
  ll <- import_val(sh)
  val <- bind_rows(val, ll)
}
#
var_label(val$nom) <- "Lecteur"
var_label(val$nerf) <- "Nerf optique (mm)"
var_label(val$gaine) <- "Gaine du nerf optique (mm)"

save(val, file = "datas/validation.RData")
load("datas/validation.RData")
