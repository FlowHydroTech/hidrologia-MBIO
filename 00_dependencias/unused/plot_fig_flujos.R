library(ggplot2)
library(tidyr)

figura_flujos <- function(
  df_long,
  title_name,
  y_name,
  path_out,
  scale,
  ymin,
  ymax
) {
  # modificar la escala del grafico
  by_y <- scale
  limits <- c(
    0,
    # 140
    round(max(df_long$data) / scale) * scale + scale
  )

  # Define custom colors and line types
  custom_colors <- c(
    "#F8766D",
    "#00BFC4",
    "#7CAE00",
    "#8494FF"
  )
  custom_linetypes <- c(
    "dashed",
    "dashed",
    "dashed",
    "dashed"
  )
  custom_linewidth <- c(0.3, 0.3, 0.3, 0.3)
  shift <- 3
  alpha_annotate <- 0
  x_annotate <- as.Date("2045-01-01")
  size_annotate <- 1.5

  ggplot(df_long, aes(x = time, y = data, group = key)) +
    geom_line(
      alpha = 1,
      aes(color = key, linetype = key, linewidth = key)
    ) +
    geom_point(size = 1, shape = 21, aes(color = key)) +
    scale_color_manual(values = custom_colors) +
    scale_linewidth_manual(values = custom_linewidth) +
    scale_linetype_manual(values = custom_linetypes) +
    labs(
      title = title_name,
      x = NULL, # Eliminar el título del eje X
      y = y_name
    ) + # Título del eje Y con superíndice
    scale_x_date(
      date_breaks = "2 years",
      date_labels = "%Y",
      limits = c(as.Date("2025-01-01"), as.Date("2052-01-01")),
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      expand = c(0, 0),
      limits = limits,
      breaks = seq(limits[1], limits[2], by = by_y),
    ) +
    geom_line(
      aes(
        y = ymax
      ),
      linetype = 2,
      linewidth = 0.1,
      alpha = alpha_annotate
    ) +
    geom_line(
      aes(
        y = ymin
      ),
      linetype = 2,
      linewidth = 0.1,
      alpha = alpha_annotate
    ) +
    geom_vline(
      xintercept = as.Date("2036-01-01"),
      linetype = 2,
      linewidth = 0.2,
      alpha = alpha_annotate,
    ) +
    annotate(
      geom = "text",
      x = x_annotate,
      y = ymax + shift,
      label = paste0("Límite Max Obs (2020-2025) = ", as.character(ymax)),
      size = size_annotate,
      alpha = alpha_annotate
    ) +
    annotate(
      geom = "text",
      x = x_annotate,
      y = ymin + shift,
      label = paste0("Límite Min Obs (2020-2025) = ", as.character(ymin)),
      size = size_annotate,
      alpha = alpha_annotate
    ) +
    coord_cartesian(
      xlim = c(as.Date("2025-01-01"), as.Date("2052-01-01")),
      ylim = c(0, limits[2]),
      clip = "off"
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom", # Mover la leyenda fuera del gráfico
      legend.justification = c(1, 0),
      legend.margin = margin(0, 0, 0, 0),
      legend.direction = "horizontal",
      legend.title = element_blank(),
      # legend.background = element_rect(fill = "white", color = "black"),
      # Rotar etiquetas del eje Y
      # axis.text.x = element_text(angle = 0, hjust = 0),
      # Centrar el título del gráfico
      plot.margin = unit(c(0.8, 0.8, 0.1, 0), "cm"),
      plot.title = element_text(hjust = 0, size = 8),
      text = element_text(size = 8),
      panel.border = element_rect(
        colour = "black",
        linewidth = 0.1,
        fill = NA
      ),
    ) +
    guides(color = guide_legend(nrow = 1, ncol = 4))

  ggsave(
    filename = paste0(path_out, ".png"),
    width = 15,
    height = 7,
    units = "cm",
    dpi = 300
  )

  # # Exportar tabla mensual
  # df_wide <- df_long |>
  #   tidyr::pivot_wider(names_from = key, values_from = data)

  # write.table(
  #   df_wide,
  #   file = paste0(path_out, "_mensual.csv"),
  #   sep = ";",
  #   row.names = FALSE,
  #   eol = "\n"
  # )

  # # # Exportar tabla anual (mean o sum)
  # df_wide_anual <- aggr_month_df(df_wide, "mean")

  # write.table(
  #   df_wide_anual,
  #   file = paste0(path_out, "_anual.csv"),
  #   sep = ";",
  #   row.names = FALSE,
  #   eol = "\n"
  # )
}
