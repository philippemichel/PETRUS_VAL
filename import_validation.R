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
  nfg <- c("nf_dt", "gn_dt", "nf_gch", "gn_gch")
  nomi <- read_ods("datas/validation.ods", sheet = sh, range = "C4:C5", col_names = FALSE)
  print(nomi)
  lect <- read_ods("datas/validation.ods", sheet = sh, range = "B11:E23", col_names = FALSE, na = nna) |>
    dplyr::filter(...1 != "zz" | is.na(...1)) |>
    mutate_all(as.numeric)
  names(lect) <- nfg
  lecteur <- lect |>
    pivot_longer(cols = everything(), values_to = "lecteur")
  exp <- read_ods("datas/validation.ods", sheet = sh, range = "R11:U23", col_names = FALSE, na = nna) |>
    dplyr::filter(...1 != "zz" | is.na(...1)) |>
    mutate_all(as.numeric)
  names(exp) <- nfg
  expert <- exp |>
    pivot_longer(cols = everything(), values_to = "expert")
  nom <- rep(paste0(nomi[1, 1], " (C", nomi[2, 1], ")"), nrow(expert))
  #
  tt <- lecteur |>
    mutate(expert = expert$expert, nom = nom) |>
    mutate(dif = abs(expert - lecteur)) |>
    mutate(type = fct_recode(name,
      "gaine" = "gn_dt",
      "gaine" = "gn_gch",
      "nerf" = "nf_dt",
      "nerf" = "nf_gch"
    )) |>
    mutate_if(is.character, as.factor)
  #
  return(tt)
}
#

tt <- NULL
for (sh in 1:nsh) {
  zz <- import_val(sh)
  tt <- rbind(tt, zz)
}
#


save(tt, file = "datas/validation.RData")
load("datas/validation.RData")
