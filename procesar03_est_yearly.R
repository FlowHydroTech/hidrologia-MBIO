source("00_dependencias/00_readData.R")
source("00_dependencias/05_plot_est_yearly.R")

# Definir vectores de datos
path_excel_vol <- c(
  "01_input/resultados_2c_5YPEX95_EST/Deficit.xlsx"
)
y_name_i <- bquote("Flujo" ~ "[" * l / s * "]")
name <- c(
  "deficit_2b_5YPEX95_EST"
)
scale_i <- 50
date_end_i <- as.Date("2052-01-01")
y_limit_i <- c(0, 250)


# parametros figura

for (i in 1:1) {
  input_i <- path_excel_vol[i]
  output_i <- paste0("02_output/", name[i], ".png")
  df_i <- read_prop_data(file = input_i)
  plot_timeseries_est_yearly(
    df = df_i,
    y_name = y_name_i,
    path_out = output_i,
    scale = scale_i,
    date_end = date_end_i,
    y_limit = y_limit_i
  )
}
print("terminado")
