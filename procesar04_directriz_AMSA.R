##### Graficos análisis directriz AMSA ####
library(readxl)
library(ggplot2)
library(tidyr)

count_above_thresholds <- function(data, thresholds) {
  sapply(thresholds, function(threshold) {
    vapply(
      data,
      function(column) {
        sum(column >= threshold, na.rm = TRUE)
      },
      integer(1)
    )
  })
}
add_false_data <- function(result_long) {
  # Agregar dato falso si todas las realizaciones son TRUE o FALSE
  # para el panel facet_wrap
  # esta funcion genera esta advertencia:
  # "Removed 2 rows containing missing values or
  # values outside the scale range (`geom_line()`)."
  false_panel <- data.frame(
    Variable = c(NA, NA),
    Count = c(NA, NA),
    realization = c(NA, NA),
    cumple = factor(c("FALSE", "TRUE"), levels = c("FALSE", "TRUE"))
  )

  # Añadimos al dataframe original
  result_long <- rbind(result_long, false_panel)
  return(result_long)
}


file_path <- c(
  "01_input/resultados_E2c_5YPEX95_EST/mineral_procesado_realizaciones.xlsx"
)
title_fig <- c(
  "Seguridad Hídrica E2c 5YPEX95 + EST LOM [2026-2052]"
)
filename_out <- c(
  "02_output/plot_AMSA_2026_2052_2c_5YPEX85_EST.png"
)
sheet_name <- "Hoja1"
# Read the sheet starting from cell B3 (2nd column, 3rd row)
#  from cell B3 (2nd column, 3rd row)
# AMSA desde 2026 al 2052:   112, 435
cell_limit_ini <- 112
cell_limit_fin <- 435
n_cell <- cell_limit_fin - cell_limit_ini + 1

for (i in c(1)) {
  data <- suppressMessages(read_excel(
    file_path[i],
    sheet = sheet_name,
    col_names = FALSE,
    range = cell_limits(c(cell_limit_ini, 2), c(cell_limit_fin, NA)),
    col_types = "numeric",
  ))

  # Segunda parte
  vector_prod <- seq(0, 190, by = 19)
  result_matrix <- count_above_thresholds(data, vector_prod)
  result_matrix_norm <- 100 * result_matrix / n_cell
  result_df <- as.data.frame(result_matrix_norm)
  colnames(result_df) <- vector_prod
  result_df$realization <- paste0("r", seq(1, 100))
  result_df$cumple <- factor(result_df[, 11] > 90, levels = c(FALSE, TRUE))

  # Convert to long format
  result_long <- pivot_longer(
    result_df,
    c(-cumple, -realization),
    names_to = "Variable",
    values_to = "Count"
  )
  result_long$Variable <- as.numeric(result_long$Variable)
  # Contar False and True
  false_count <- sum(result_df$cumple == FALSE)
  true_count <- sum(result_df$cumple == TRUE)
  # agregar datos falsos para asegurar que aparezcan en el facet_wrap
  result_long <- add_false_data(result_long)

  # # Plot with ggplot2
  ggplot(
    result_long,
    aes(x = Variable, y = Count, group = realization, color = cumple)
  ) +
    facet_wrap(
      ~cumple,
      labeller = labeller(
        cumple = c(
          "FALSE" = paste0("Nº realizaciones incumplimiento: ", false_count),
          "TRUE" = paste0("Nº realizaciones cumplimiento: ", true_count)
        )
      )
    ) +
    geom_line(linewidth = 0.2, linetype = "solid") +
    geom_vline(
      xintercept = 190,
      linetype = "dashed",
      color = "black",
      linewidth = 0.2
    ) +
    geom_hline(
      yintercept = 90,
      linetype = "dashed",
      color = "black",
      linewidth = 0.2
    ) +
    # stat_brace(outerstart = 85, width = 1, rotate = 90) +
    labs(
      x = "Tratamiento de Mineral (ktpd)",
      y = "Porcentaje de tiempo\nsobre la producción (%)",
      title = title_fig[i]
    ) +
    scale_y_continuous(
      expand = c(0, 0),
      limits = c(0, 100),
      breaks = seq(0, 100, by = 10) # divide labels by 10
    ) +
    scale_x_continuous(
      expand = c(0, 0),
      limits = c(0, 190),
      breaks = seq(0, 190, by = 19)
    ) +
    coord_cartesian(
      xlim = c(0, 190),
      ylim = c(0, 100),
      clip = "off"
    ) +
    theme_minimal() +
    theme(
      text = element_text(size = 6),
      legend.position = "none",
      panel.spacing = unit(1, "lines"),
      plot.margin = unit(c(0, 0.5, 0, 0), "cm")
    )

  ggsave(
    filename = filename_out[i],
    width = 15,
    height = 5,
    units = "cm",
    dpi = 200
  )
  print(filename_out[i])
}
