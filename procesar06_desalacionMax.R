# Este codigo tiene como objetivo comparar los C1, C3 y C4
# Cargar la librería
library(openxlsx)
library(dplyr)
library(tidyr)
library(ggplot2)
library(openxlsx)
library(stringi)
source("00_dependencias/00_readData.R")
source("00_dependencias/04_plot_max_desalacion.R")

# open excels
path_excel <- c(
  "01_input/resultados_desalacion_max/desalacion_max_R1_R2.xlsx",
  "01_input/resultados_desalacion_max/desalacion_max_R3.xlsx"
)

# Datos para leer la informacion
key_list1 <- c("INCO + PAO", "FA", "EVU", "TOTAL (INCO+PAO+FA+EVU)")
key_level <- c("E2c", "E2d")
cols1 <- c(2, 3, 4, 5)

df_long1 <- read_det_data(
  file = path_excel[1],
  sheet = "Hoja1",
  start_row = 4,
  cols = cols1,
  delta_time = "1 day",
  start_time = as.Date("2017-01-01"),
  end_time = as.Date("2052-12-31"),
  key_list = key_list1
)

df_long2 <- read_det_data(
  file = path_excel[2],
  sheet = "Hoja1",
  start_row = 4,
  cols = cols1,
  delta_time = "1 day",
  start_time = as.Date("2017-01-01"),
  end_time = as.Date("2052-12-31"),
  key_list = key_list1
)

# Agregar niveles
df_long1$key_level <- key_level[1]
df_long2$key_level <- key_level[2]

# bind
df_long3 <- rbind(df_long1, df_long2)

# graficar
path_out1 <- "02_output/desalacion_max"
plot_timeseries_max_desalacion(df_long = df_long3, path_out = path_out1)

print("terminado")
