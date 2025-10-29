source("00_dependencias/00_readData.R")
source("00_dependencias/04_functions_txt_goldsim.R")
# Tratamiento de mineral
# var_name <- "Mineral_To_Planta_corr"
# input_file <- "01_input/sinFA_PAOprogresivo_pexc85_volini/Mineral Procesado_1.txt"
# subfijo_out1 <- "02_output/Mineral_To_Planta_corr"
# wb_template1 <- "00_dependencias/template_excel/var_year.xlsx"
# input_array <- read_txt_goldsim(file = input_file)
# function_anual_var_all(
#   input_df = input_array[[var_name]],
#   wb_template = wb_template1,
#   subfijo_out = subfijo_out1
# )

# # Volumen Simulado
# var_name <- "Volumen simulado"
# input_file <- "01_input/sinFA_PAOprogresivo_pexc85_volini/Volumen Mauro.txt"
# subfijo_out1 <- "02_output/volumen_laguna"
# wb_template1 <- "00_dependencias/template_excel/var_daily.xlsx"
# input_array <- read_txt_goldsim(file = input_file)
# function_anual_var_all(
#   input_df = input_array[[var_name]],
#   wb_template = wb_template1,
#   subfijo_out = subfijo_out1
# )

# Hoja Anual Balance
input_file <- "01_input/Resultados_anual.txt"
input_array <- read_txt_goldsim(file = input_file)
wb_template1 <- "00_dependencias/template_excel/Resultados_anual.xlsx"
name_out1 <- "02_output/Resultados_anual"
function_resultados_anual_per(
  array = input_array,
  wb_template = wb_template1,
  name_out = name_out1
)
# function_resultados_anual_pexc(
#   array = input_array,
#   wb_template = wb_template1,
#   subfijo_out = subfijo_out1
# )

# # Hoja Anual Balance ICMM
# input_file <- "01_input/sinFA_PAOprogresivo_pexc85_volini/Resultados_ICMM.txt"
# subfijo_out1 <- "02_output/Resultados_ICMM"
# wb_template1 <- "00_dependencias/template_excel/otros/Resultados_ICMM_2028.xlsx"
# input_array <- read_txt_goldsim(file = input_file)
# function_resultados_anual_pexc(
#   array = input_array,
#   wb_template = wb_template1,
#   subfijo_out = subfijo_out1
# )
