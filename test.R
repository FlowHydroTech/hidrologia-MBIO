source("00_dependencias/00_readData.R")

# Definir vectores de datos
path_excel_vol <- c(
  "01_input/resultados_E2c_5YPEX95_EST/volumen_laguna_prob.xlsx",
  "01_input/resultados_E2c_5YPEX95_EST/Deficit.xlsx"
)

# parametros figura

input_i <- path_excel_vol[2]
delta_time_i <- "1 year"
df_i <- read_est_data(file = input_i, delta_time = delta_time_i)

print(df_i)
