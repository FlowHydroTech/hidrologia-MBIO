source("00_dependencias/00_readData.R")
source("00_dependencias/03_func_txt_goldsim.R")

# Ejemplo fun_det_split_files
# input_file <- "01_input/Resultados_anual.txt"
# input_array <- read_txt_goldsim(file = input_file)
# wb_template1 <- "00_dependencias/template_excel/Resultados_anual.xlsx"
# superfijo1 <- c("R1", "R2", "R3", "R4", "R5")
# path_out1 <- "02_output/Resultados_anual"
# func_det_split_files(
#   array = input_array,
#   wb_template = wb_template1,
#   superfijo = superfijo1,
#   path_out = path_out1
# )

# Ejemplo func_det_one_file
# input_file <- "01_input/test_data/Volumen Mauro.txt"
input_file <- "01_input/test_data/R_LagunaTM.txt"
input_array <- read_txt_goldsim2(file = input_file)
# wb_template1 <- "00_dependencias/template_excel/Resultados_anual.xlsx"
# superfijo1 <- c("R1", "R2", "R3", "R4", "R5")
# path_out1 <- "02_output/Resultados_anual"
# func_det_split_files(
#   array = input_array,
#   wb_template = wb_template1,
#   superfijo = superfijo1,
#   path_out = path_out1
# )
str(input_array)
