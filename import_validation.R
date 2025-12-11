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
nsh <- read_ods("datas/validation2.ods", sheet = 1, range = "A23", col_names = FALSE)
nsh <- nsh[[1, 1]]

#
import_val <- function(sh) {
  nna <- c("", " ", "NA", "ND", "#DIV/0 !", "NC")
  nom <- read_ods("datas/validation2.ods", sheet = sh, range = "C4:C5", col_names = FALSE)
  print(nom)
  lect <- read_ods("datas/validation2.ods", sheet = sh, range = "B11:E22", col_names = FALSE, na = nna)
  exp <- read_ods("datas/validation2.ods", sheet = sh, range = "R11:U22", col_names = FALSE, na = nna)
  dif <- abs(lect - exp)
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
