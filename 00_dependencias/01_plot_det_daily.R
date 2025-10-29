library(ggplot2)
library(tidyr)
#figura_comparativa
plot_timeseries_det_daily <- function(
  df_long,
  y_name,
  path_out,
  scale,
  date_end,
  y_limit
) {
	
  # Crear marcas de tiempo en el eje X
  x_annotate <- as.POSIXlt(date_end)
  x_annotate$mday <- 1
  x_annotate$mon <- 1
  x_annotate$year <- x_annotate$year + 1
  x_annotate <- as.Date(x_annotate)

  x_scale_end <- as.POSIXlt(date_end)
  x_scale_end$mday <- 1
  x_scale_end$mon <- 0
  x_scale_end$year <- x_scale_end$year + 2
  x_scale_end <- as.Date(x_scale_end)

  x_coord_end <- as.POSIXlt(date_end)
  x_coord_end$mday <- 1
  x_coord_end$mon <- 0
  # [CAMBIAR] es 1 en vez de 0
  x_coord_end$year <- x_coord_end$year + 1
  x_coord_end <- as.Date(x_coord_end)

  # [CAMBIAR]
  # x_annotate <- x_coord_end

  # Eliminar datos que no corresponden
  df_long <- df_long[
    as.Date("2026-01-01") <= df_long$time &
      date_end >= df_long$time,
  ]
  rownames(df_long) <- NULL

  # Define custom colors and line types
  custom_colors <- c(
    "#F8766D",
    "#00BFC4",
    "#7CAE00",
    "#8494FF",
    "orange",
    "green"
  )
  custom_linewidth <- c(0.3, 0.3, 0.3, 0.3, 0.3, 0.3)
  custom_linetypes <- c(
    "solid",
    "solid",
    "solid",
    "solid",
    "solid",
    "solid"
  )
  shift <- scale * 0.10
  alpha_annotate <- 1
  size_annotate <- 3

  ggplot(df_long, aes(x = time, y = data, group = key)) +
    geom_line(
      alpha = 1,
      aes(color = key, linetype = key, linewidth = key)
    ) +
    scale_color_manual(values = custom_colors) +
    scale_linewidth_manual(values = custom_linewidth) +
    scale_linetype_manual(values = custom_linetypes) +
    labs(
      x = NULL,
      y = y_name
    ) +
    scale_x_date(
      date_breaks = "2 years",
      date_labels = "%Y",
      limits = c(as.Date("2026-01-01"), x_annotate),
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      expand = c(0, 0),
      limits = y_limit + c(0, scale * 0.1),
      breaks = seq(y_limit[1], y_limit[2], by = scale),
    ) +
    geom_line(
      aes(
        y = 5
      ),
      linetype = 2,
      linewidth = 0.2,
      alpha = alpha_annotate
    ) +
    geom_line(
      aes(
        y = 4
      ),
      linetype = 2,
      linewidth = 0.2,
      alpha = alpha_annotate
    ) +
    geom_line(
      aes(
        y = 0.4
      ),
      linetype = 2,
      linewidth = 0.2,
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
      y = 5,
      label = "5~hm^3",
      parse = TRUE,
      size = size_annotate,
      alpha = alpha_annotate,
      hjust = 0,
      vjust = 0
    ) +
    annotate(
      geom = "text",
      x = x_annotate,
      y = 4,
      label = "4~hm^3",
      parse = TRUE,
      size = size_annotate,
      alpha = alpha_annotate,
      hjust = 0,
      vjust = 0
    ) +
    annotate(
      geom = "text",
      x = x_annotate,
      y = 0.4,
      label = "0.4~hm^3",
      parse = TRUE,
      size = size_annotate,
      alpha = alpha_annotate,
      hjust = 0,
      vjust = 0
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
      legend.position = "bottom",
      legend.title = element_blank(),
      legend.justification = c(0.5, 0),
      legend.margin = margin(0, 0, 0, 0),
      legend.direction = "horizontal",
      plot.margin = unit(c(0.8, 1.1, 0.1, 0), "cm"),
      plot.title = element_text(hjust = 0),
      text = element_text(size = 12),
      panel.border = element_rect(
        colour = "black",
        linewidth = 0.1,
        fill = NA
      )
    ) +
    guides(color = guide_legend(nrow = 1, ncol = length(unique(df_long$key))))

  ggsave(
    filename = paste0(path_out, ".png"),
    width = 25,
    height = 10,
    units = "cm",
    dpi = 300
  )
}
