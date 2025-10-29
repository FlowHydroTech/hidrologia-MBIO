library(openxlsx)
library(tidyr)

read_det_data <- function(
  file,
  sheet,
  start_row,
  cols,
  delta_time,
  start_time,
  end_time,
  key_list
) {
  df <- openxlsx::read.xlsx(
    xlsxFile = file,
    sheet = sheet,
    colNames = FALSE,
    startRow = start_row,
    cols = cols,
  )

  col_names <- names(df)

  time <- seq(start_time, end_time, by = delta_time)
  dft <- cbind(time, df)
  rownames(dft) <- NULL

  # Crear long data.frame

  df_long <-
    pivot_longer(
      dft,
      cols = -time, # columnas que quieres convertir
      values_to = "data", # nueva columna con los valores
      names_to = "key" # nueva columna con los nombres de las variables
    )
  # reemplazar nombres de las columnas por las key_list
  replacements <- setNames(key_list, col_names)
  df_long$key <- replacements[df_long$key]

  # Asegurar el orden de key_list
  df_long$key <- factor(df_long$key, levels = key_list)
  return(df_long)
}

read_txt_goldsim <- function(file) {
  # Esta funcion tiene como objetivo leer un archivo de texto de Goldsim
  # y devolver un array que contiene dataframes con los elementos.

  # Leer Texto
  data_lines <- readLines(file, encoding = "UTF-8")
  # Eliminar la columna extra al final de los datos
  clean_lines <- sub("\t$", "", data_lines)
  # Identificar cuando empiezan los resultados
  result_starts <- grep("^!Result:", clean_lines)
  result_ends <- c(result_starts[-1], length(clean_lines))
  # Se le suma 3 porque ahi realmente empiezan
  idx_start <- result_starts + 3
  idx_end <- result_ends
  # Se le restan 2 , excepto en el ultimo elemento del vector idx_end,
  # ya que es ahi donde termina el archivo
  idx_end[-length(idx_end)] <- idx_end[-length(idx_end)] - 2

  # Crear array para guardar data.frames
  n <- length(idx_start)
  array <- vector(mode = "list", length = n)
  names_var <- character(n)

  # Iterar en todos los resultados del archivo de texto
  for (i in seq_along(idx_start)) {
    data_i <- clean_lines[idx_start[i]:idx_end[i]]

    df_i <- read.table(
      text = data_i,
      sep = "\t",
      header = FALSE,
    )

    # Se guarda el dataframe, se ignora la primera columna porque es el tiempo.
    df_i <- df_i[, 2:ncol(df_i)]
    colnames(df_i) <- paste0("V", seq_len(ncol(df_i)))
    array[[i]] <- round(df_i, digits = 3)

    # guardar nombre
    name_i <- sub("^!Result:\\s*", "", clean_lines[result_starts[i]])
    names_var[i] <- name_i
  }

  # Agregar nombres a array
  names(array) <- names_var
  return(array)
}


read_est_data <- function(file) {
  df <- openxlsx::read.xlsx(
    xlsxFile = file,
    sheet = "Hoja1",
    colNames = FALSE,
  )
  df_chr <- df[3, 1:12]
  row_name <- mutate_names(x = df_chr)
  row_name[1] <- "time"
  row_name <- paste0("var_", row_name)
  df_values <- data.frame(sapply(df[4:nrow(df), 1:12], as.numeric))
  df_date <- as.Date(paste0(df_values[, 1], "-01-01"))
  # df_date <- as.Date(df_values[, 1], origin = "1899-12-30")
  df_values[1] <- df_date

  colnames(df_values) <- row_name
  return(df_values)
}


read_vertical_data <- function(
  file,
  sheet,
  start_row,
  cols,
  time_str,
  start_time,
  end_time
) {
  df <- openxlsx::read.xlsx(
    xlsxFile = file,
    sheet = sheet,
    colNames = FALSE,
    startRow = start_row,
    cols = cols,
  )

  col_name <- c("var")
  names(df) <- col_name

  time <- seq(start_time, end_time, by = time_str)
  dft <- cbind(time, df)
  rownames(dft) <- NULL
  names(dft) <- c("time", "data")
  return(dft)
}

aggr_month_df <- function(df, func) {
  df$year_col <- strftime(df$time, "%Y")

  group <- df |>
    dplyr::select(-time) |>
    dplyr::group_by(year_col)

  by_func <- group |>
    dplyr::summarize_all(func)

  df_out <- as.data.frame(by_func)
  return(df_out)
}


read_horizontal_data <- function(
  file,
  sheet,
  rows,
  cols,
  time_str,
  start_time,
  end_time
) {
  # Esta funcion lee los excels de balance integral MBIO.
  # time_str es 'year' o 'month' para la funcion de R "seq"
  # ej:
  # df <- read_transposed_data(
  #   file = path_excel,
  #   sheet = sheet_flow,
  #   rows = rows_flow,
  #   cols = cols_flow,
  #   time_str = time_str,
  #   start_time = as.Date("2024-01-01"),
  #   end_time = as.Date("2052-12-01")
  # )

  df <- openxlsx::read.xlsx(
    xlsxFile = file,
    sheet = sheet,
    colNames = FALSE,
    rows = rows,
    cols = cols,
  )

  df_chr <- df[, 1]
  col_name <- mutate_names(x = df_chr)

  dft <- as.data.frame(t(df[, -1]), stringsAsFactors = FALSE)

  names(dft) <- "data"

  time <- seq(start_time, end_time, by = time_str)

  dft <- cbind(time, dft)
  rownames(dft) <- NULL
  return(dft)
}

mutate_names <- function(x) {
  # Esta funcion transforma character a minusculas y con _ en los espacios
  clean_string <- stringi::stri_trans_general(x, "Latin-ASCII")
  pattern <- "[()+]:"
  result_string <- gsub(pattern, "", clean_string)
  tolower_string <- tolower(result_string)
  new_names <- gsub(" +", "_", tolower_string)
  new_names <- gsub("\\.", "", new_names)
  return(new_names)
}
