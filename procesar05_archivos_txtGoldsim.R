source("00_dependencias/00_readData.R")
source("00_dependencias/03_func_txt_goldsim.R")

# Hoja Anual Balance
input_file <- "01_input/Resultados_anual.txt"
input_array <- read_txt_goldsim(file = input_file)
wb_template1 <- "00_dependencias/template_excel/Resultados_anual.xlsx"
superfijo1 <- c("R1", "R2", "R3", "R4", "R5")
path_out1 <- "02_output/Resultados_anual"
func_split_files(
  array = input_array,
  wb_template = wb_template1,
  superfijo = superfijo1,
  path_out = path_out1
)
