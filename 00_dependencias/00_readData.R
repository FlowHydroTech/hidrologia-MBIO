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
  # Esta funcion tiene como objetivo leer archivos de excel de goldsim
  # que contengan varias realizaciones deterministicas.
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
  # Identificar cuando empiezan y terminan los resultados
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

  # Guardar la variable del tiempo solo una vez
  data_1 <- clean_lines[idx_start[1]:idx_end[1]]

  df_1 <- read.table(
    text = data_1,
    sep = "\t",
    header = FALSE,
  )
  # Se guarda el dataframe, se ignora la primera columna porque es el tiempo.
  df_1 <- as.Date(df_1[, 1])
  colnames(df_1) <- "time"
  array[[1]] <- df_1

  # guardar nombre
  names_var[i] <- "time"

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
    # array[[i]] <- round(df_i, digits = 3)
    array[[i]] <- df_i

    # guardar nombre
    name_i <- sub("^!Result:\\s*", "", clean_lines[result_starts[i]])
    names_var[i] <- name_i
  }

  # Agregar nombres a array
  names(array) <- names_var
  return(array)
}

read_txt_goldsim2 <- function(file) {
  # Leer y limpiar líneas del archivo
  lines <- sub("\t$", "", readLines(file, encoding = "UTF-8"))

  # Detectar bloques de resultados
  starts <- grep("^!Result:", lines)
  ends <- c(starts[-1] - 2, length(lines)) # Ajuste de fin de bloque
  starts <- starts + 3 # Ajuste de inicio de bloque

  # Inicializar lista de resultados
  results <- vector("list", length(starts) + 1) # +1 para la variable de tiempo

  # Extraer la columna de tiempo desde el primer bloque
  time_block <- lines[starts[1]:ends[1]]
  time_df <- read.table(text = time_block, sep = "\t", header = FALSE)
  time <- parse_date(time_df[, 1])
  results[[1]] <- time
  names(results)[1] <- "time"

  # Extraer cada bloque como data.frame (sin la columna de tiempo)
  for (i in seq_along(starts)) {
    block <- lines[starts[i]:ends[i]]
    df <- read.table(text = block, sep = "\t", header = FALSE)
    df <- df[, -1] # Eliminar columna de tiempo
    colnames(df) <- paste0("R", seq_len(ncol(df)))
    results[[i + 1]] <- df
    names(results)[i + 1] <- sub("^!Result:\\s*", "", lines[starts[i] - 3])
  }

  return(results)
}


parse_date <- function(x) {
  # Esta funcion transforma las fechas formato %d/%m/%Y y %Y%
  # Probar el primer elemento si tiene "/" es una fecha del tipo "%d/%m/%Y"
  # si no es una fehca del tipo "%Y"
  test <- grepl(pattern = "/", x[1])

  if (test) {
    result_date <- as.Date(x, format = "%d/%m/%Y")
  } else {
    x_try <- paste0(x, "-01-01")
    result_date <- as.Date(x_try, format = "%Y-%m-%d")
  }
  return(result_date)
}


read_est_data <- function(file, delta_time) {
  df <- openxlsx::read.xlsx(
    xlsxFile = file,
    sheet = "Hoja1",
    colNames = FALSE,
  )
  # Esta funcion lee una archivo de excel de simulaciones estocásticas,
  # en dónde está los percentiles de la variable.
  # delta_time = "1 day" or "1 year"

  # Crear tiempo
  start_time <- as.Date("2017-01-01")
  end_time <- as.Date("2052-12-31")
  time <- as.data.frame(
    seq(start_time, end_time, by = delta_time),
  )

  # Leer y transformar data
  df_chr <- df[3, 2:12]
  row_name <- mutate_names(x = df_chr)
  row_name <- paste0("var_", row_name)
  df_values <- data.frame(
    sapply(df[4:nrow(df), 2:12], function(x) round(as.numeric(x), 4))
  )

  # concadenar

  dft <- cbind(time, df_values)
  rownames(dft) <- NULL
  colnames(dft) <- c("time", row_name)

  return(dft)
}


read_vertical_data <- function(
  file,
  sheet,
  start_row,
  cols,
  delta_time,
  start_time,
  end_time
) {
  # La funcion lee un archivo de excel con la data ordenada de forma vertical
  df <- openxlsx::read.xlsx(
    xlsxFile = file,
    sheet = sheet,
    colNames = FALSE,
    startRow = start_row,
    cols = cols,
  )

  col_name <- c("var")
  names(df) <- col_name

  time <- seq(start_time, end_time, by = delta_time)
  dft <- cbind(time, df)
  rownames(dft) <- NULL
  names(dft) <- c("time", "data")
  return(dft)
}

aggr_month_df <- function(df, func) {
  # Esta funcion toma un dataframe (df) con una columna llamada "time" y
  # agrega la informacion con la funcion "func" (sum or avg)
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
  # Esta funcion lee datos que están en las filas o de forma horizontal
  # en el archivo Resultados_anual.xlsx (hoja resumen)
  df <- openxlsx::read.xlsx(
    xlsxFile = file,
    sheet = sheet,
    colNames = FALSE,
    rows = rows,
    cols = cols,
  )

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
