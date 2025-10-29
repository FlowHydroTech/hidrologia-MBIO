source("00_dependencias/00_readData.R")


# open excels
path_excel_vol <- c(
  "01_input/resultados_DET_2b_5YPEX85_LOM_PEX90_PEX85/volumen_laguna.xlsx"
)

# Completar datos
title <- "volumen_laguna_E2b_5YPEX95_alpha"
key_list1 <- c(
  "test1",
  "test2",
  "test3"
)

y_axis <- bquote("Volumen" ~ "[" * hm^"3" * "]")
path_out1 <- paste0("02_output/", title)
cols1 <- c(2, 3, 4)
y_limit1 <- c(0, 10)
scale1 <- 2
date_end1 <- as.Date("2052-12-31")
df_long <- data.frame()

df_i <- read_deterministic_data(
  file = path_excel_vol,
  sheet = "Hoja1",
  start_row = 4,
  cols = cols1,
  delta_time = "1 day",
  start_time = as.Date("2017-01-01"),
  end_time = as.Date("2052-12-31"),
  key_list = key_list1
)
