library(ggplot2)
library(tidyr)
library(dplyr)

plot_timeseries_est_yearly <- function(
  df,
  y_name,
  path_out,
  scale,
  date_end,
  y_limit
) {
  x_coord_end <- as.POSIXlt(date_end)
  x_coord_end$mday <- 1
  x_coord_end$mon <- 0
  x_coord_end$year <- x_coord_end$year + 0
  x_coord_end <- as.Date(x_coord_end)

  # Eliminar datos que no corresponden
  df <- df[
    as.Date("2026-01-01") <= df$var_time &
      x_coord_end >= df$var_time,
  ]
  rownames(df) <- NULL
  custom_color <- c(
    "#C8D77F",
    "#93E7C5",
    "#4A8BFF",
    "#012C89",
    "#EE1C25",
    "#FFE806"
  )

  # Graficar
  shift <- scale * 0.1
  alpha_annotate <- 0.5
  size_annotate <- 3
  p <- ggplot(df, aes(x = var_time)) +
    geom_ribbon(
      aes(
        ymin = var_001,
        ymax = var_099,
        fill = "1%/99%"
      ),
      alpha = 0.5
    ) +
    geom_ribbon(
      aes(
        ymin = var_01,
        ymax = var_09,
        fill = "10%/90%"
      ),
      alpha = 1
    ) +
    geom_ribbon(
      aes(
        ymin = var_02,
        ymax = var_08,
        fill = "20%/80%"
      ),
      alpha = 1
    ) +
    geom_ribbon(
      aes(
        ymin = var_04,
        ymax = var_06,
        fill = "40%/60%"
      ),
      alpha = 1
    ) +
    geom_line(aes(
      y = var_mean,
      colour = "Promedio"
    )) +
    geom_line(aes(
      y = var_05,
      colour = "50%"
    )) +
    geom_vline(
      xintercept = as.Date("2036-01-01"),
      linetype = 2,
      linewidth = 0.2
    ) +
    scale_fill_manual(
      name = "",
      values = c(
        "1%/99%" = custom_color[1],
        "10%/90%" = custom_color[2],
        "20%/80%" = custom_color[3],
        "40%/60%" = custom_color[4],
        "Promedio" = "transparent",
        "50%" = "transparent"
      )
    ) +
    scale_colour_manual(
      name = "",
      values = c(
        "1%/99%" = "transparent",
        "10%/90%" = "transparent",
        "20%/80%" = "transparent",
        "40%/60%" = "transparent",
        "Promedio" = custom_color[5],
        "50%" = custom_color[6]
      )
    ) +
    labs(
      x = NULL,
      y = y_name
    ) +
    scale_x_date(
      date_breaks = "2 years",
      date_labels = "%Y",
      limits = c(as.Date("2026-01-01"), x_coord_end),
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      expand = c(0, 0),
      limits = y_limit + c(0, scale * 0.1),
      breaks = seq(y_limit[1], y_limit[2], by = scale),
    ) +
    annotate(
      geom = "text",
      x = as.Date("2026-01-01"),
      y = y_limit[2] + shift,
      label = "Aguas Continentales",
      size = size_annotate,
      alpha = alpha_annotate,
      hjust = 0,
      vjust = 0
    ) +
    annotate(
      geom = "text",
      x = as.Date("2036-01-01"),
      y = y_limit[2] + shift,
      label = "Fin de Aguas Continentales",
      size = size_annotate,
      alpha = alpha_annotate,
      hjust = 0,
      vjust = 0
    ) +
    coord_cartesian(
      xlim = c(as.Date("2026-01-01"), x_coord_end),
      ylim = c(y_limit[1], y_limit[2]),
      clip = "off"
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom", # Mover la leyenda fuera del gráfico
      legend.direction = "horizontal",
      legend.title = element_blank(),
      legend.margin = margin(t = 0, unit = "cm"),
      plot.margin = unit(c(0.8, 1.1, 0.1, 0), "cm"),
      plot.title = element_text(hjust = 0),
      text = element_text(size = 12),
      panel.border = element_rect(
        colour = "black",
        linewidth = 0.1,
        fill = NA
      )
    )

  ggsave(
    filename = path_out,
    width = 25,
    height = 10,
    units = "cm",
    dpi = 300
  )
}
