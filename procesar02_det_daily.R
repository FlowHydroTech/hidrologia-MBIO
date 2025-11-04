# Este codigo tiene como objetivo comparar los C1, C3 y C4
# Cargar la librería
library(openxlsx)
library(dplyr)
library(tidyr)
library(ggplot2)
library(openxlsx)
library(stringi)
source("00_dependencias/00_readData.R")
source("00_dependencias/01_plot_det_daily.R")

# open excels
path_excel_vol <- c(
  "01_input/resultados_pexc_ALL/volumen_laguna.xlsx"
)
# path_excel_vol <- c(
#   "01_input/resultados_pexc_ALL/PPlant_from_desaladora_inflow.xlsx"
# )
# path_excel_vol <- c(
#   "01_input/resultados_pexc_ALL/deficit.xlsx"
# )

# Completar datos
title <- "volumen_laguna_DET_ALL"
key_list1 <- c("E2c PEX85", "E2c 5YPEX95 + PEX85", "E2d 5YPEX95 + PEX85")

# y_axis <- bquote("Flujo" ~ "[" * l / s * "]")
y_axis <- bquote("Volumen" ~ "[" * hm^"3" * "]")

path_out1 <- paste0("02_output/", title)
cols1 <- c(2, 3, 4)
y_limit1 <- c(0, 20)
scale1 <- 5
date_end1 <- as.Date("2052-12-31")

df_long <- read_det_data(
  file = path_excel_vol,
  sheet = "Hoja1",
  start_row = 4,
  cols = cols1,
  delta_time = "1 day",
  start_time = as.Date("2017-01-01"),
  end_time = as.Date("2052-12-31"),
  key_list = key_list1
)

plot_timeseries_det_daily(
  df_long = df_long,
  y_name = y_axis,
  path_out = path_out1,
  scale = scale1,
  date_end = date_end1,
  y_limit = y_limit1
)

print("terminado")
