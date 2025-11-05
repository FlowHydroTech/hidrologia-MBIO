library(openxlsx)

function_calc_quantile <- function(df, perc) {
  # Esta funcion calcula los percentiles pero para ello se necesitan los
  # datos de las 100 realizaciones.
  n <- length(df)
  # Ordenar los datos de menor a mayor
  vect <- sort(unlist(df, use.names = FALSE))
  # Se generan probabilidades de 0.005 a 0.995 en 100 realizaciones
  probs <- seq(0 + 1 / (2 * n), 1 - 1 / (2 * n), by = 1 / n)
  # Obtener el primer valor
  # supuesto, mantiene la pendiente de los valores superiores)
  m1 <- (probs[2] - probs[1]) / (vect[2] - vect[1])
  vect1 <- vect[1] - (probs[1] - 0) / m1
  # Obtener el ultimo valor
  # supuesto, mantiene la pendiente de los valores inferiores)
  m2 <- (probs[n] - probs[n - 1]) / (vect[n] - vect[n - 1])
  vect2 <- vect[n - 1] + (1 - probs[n]) / m2
  # agregar inicio y final
  vect <- c(vect1, vect, vect2)
  probs <- c(0, probs, 1)

  # Interpolar entre intervalos para obtener el percentil deseado
  interp_val <- approx(probs, vect, xout = perc)

  return(interp_val$y)
}


func_est_split_files <- function(array, wb_template, name_out) {
  # esta funcion esta diseñada para exportar distintos percentiles de una
  # simulacion estocastico a una hoja de excel template (wb_template)
  superfijo <- "_p50"
  name_out <- paste0(name_out, superfijo, ".xlsx")
  # Load the existing workbook
  wb <- loadWorkbook(wb_template)

  quantile <- data.frame(lapply(array, function(df) {
    apply(df, 1, function(row) function_calc_quantile(row, perc = 0.5))
  }))

  # Add or overwrite content in an existing sheet
  writeData(
    wb,
    sheet = "Hoja1", # Use the existing sheet's name
    x = quantile, # The data frame or matrix you're writing
    startRow = 4,
    startCol = 2,
    colNames = FALSE
  )

  # Save workbook
  saveWorkbook(wb, name_out, overwrite = TRUE)

  # print
  print(name_out[1])
}

func_one_file <- function(
  array,
  wb_template,
  col_names,
  path_out
) {
  # Esta funcion guarda todas las realizaciones en un solo archivo de excel.
  # TODO quizás falte especificar la variable que se quiere guardar
  names(array) <- col_names
  # Load the existing workbook
  wb <- loadWorkbook(wb_template)

  writeData(
    wb,
    sheet = "Hoja1", # Use the existing sheet's name
    x = input_df, # The data frame or matrix you're writing
    startRow = 2,
    startCol = 2,
    colNames = FALSE
  )

  # Save workbook
  saveWorkbook(wb, path_out, overwrite = TRUE)

  # print
  print(name_out)
}


func_split_files <- function(array, wb_template, superfijo, path_out) {
  # Esta funcion divide las variables de distintas realizaciones en varios
  # archivos excel
  name_out <- paste0(path_out, "_", superfijo, ".xlsx")

  # Load the existing workbook
  wb <- loadWorkbook(wb_template)

  for (i in 1:seq_along(superfijo)) {
    new_df <- data.frame(
      lapply(array, function(df) df[[i]])
    )

    # Add or overwrite content in an existing sheet
    writeData(
      wb,
      sheet = "Hoja1", # Use the existing sheet's name
      x = new_df, # The data frame or matrix you're writing
      startRow = 4,
      startCol = 2,
      colNames = FALSE
    )

    # Save workbook
    saveWorkbook(wb, name_out[i], overwrite = TRUE)

    # print
    print(name_out[i])
  }
}
