source("00_dependencias/00_readData.R")
source("00_dependencias/02_plot_est_daily.R")

# Definir vectores de datos
path_excel_vol <- c(
  "01_input/resultados_5YPEX95_EST/volumen_laguna_prob.xlsx"
)
date_end_i <- as.Date("2052-12-31")
name <- c(
  "2b_5YPEX95_EST"
)

# parametros figura

for (i in 1:1) {
  input_i <- path_excel_vol[i]
  output_i <- paste0("02_output/", name[i], ".png")
  df_i <- read_prop_data(file = input_i)
  plot_timeseries_est_daily(
    df = df_i,
    output = output_i,
    date_end = date_end_i
  )

  print(output_i)
}
