library(openxlsx)

function_calc_quantile <- function(df, perc) {
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

function_anual_var_all <- function(
  input_df,
  wb_template,
  subfijo_out
) {
  superfijo <- c("pexc95", "pexc90", "pexc85", "pexc80", "pexc50", "pexc15")
  name_out <- paste0(subfijo_out, ".xlsx")
  names(input_df) <- superfijo
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
  saveWorkbook(wb, name_out, overwrite = TRUE)

  # print
  print(name_out)
}

function_resultados_anual_var <- function(input_df, wb_template, subfijo_out) {
  superfijo <- c("pexc95", "pexc90", "pexc85", "pexc80", "pexc50", "pexc15")
  name_out <- paste0(subfijo_out, "_", superfijo, ".xlsx")
  # Load the existing workbook
  wb <- loadWorkbook(wb_template)
  # Realizaicone
  real <- c(1, 2, 3, 4, 5, 6)

  for (i in seq_along(real)) {
    # Seleccionar columnas (el +1 se le aplica por que la primera columna es
    # Tiempo
    real_i <- real[i]
    df_i <- input_df[real_i]

    # Add or overwrite content in an existing sheet
    writeData(
      wb,
      sheet = "Hoja1", # Use the existing sheet's name
      x = df_i, # The data frame or matrix you're writing
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

function_resultados_anual_per <- function(array, wb_template, name_out) {
  # superfijo <- c("p10")
  # name_out <- paste0(name_out, ".xlsx")
  # names(input_df) <- superfijo
  # # Load the existing workbook
  # wb <- loadWorkbook(wb_template)

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

function_resultados_anual_pexc <- function(array, wb_template, subfijo_out) {
  superfijo <- c("pexc95", "pexc90", "pexc85", "pexc80", "pexc50", "pexc15")
  name_out <- paste0(subfijo_out, "_", superfijo, ".xlsx")
  # Load the existing workbook
  wb <- loadWorkbook(wb_template)

  for (i in 1:6) {
    # Seleccionar columnas (el +1 se le aplica por que la primera columna es
    # Tiempo
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
