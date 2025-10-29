library(ggplot2)
library(tidyr)

## add text to each face_wrap
# https://stackoverflow.com/questions/11889625/annotating-text-on-individual-facet-in-ggplot2

plot_timeseries_max_desalacion <- function(
  df_long,
  path_out
) {
  # Eliminar datos que no corresponden
  df_long <- df_long[
    as.Date("2026-01-01") <= df_long$time &
      as.Date("2053-01-01") >= df_long$time,
  ]

  # Graficar

  ggplot(
    df_long,
    aes(x = time, y = data, color = key_level)
  ) +
    scale_color_manual(
      values = c(
        "E2c" = "#F8766D",
        "E2d" = "#00BFC4",
        "Fin de aguas continentales" = "#000000"
      )
    ) +
    facet_wrap(~key) +
    geom_vline(
      aes(
        xintercept = as.Date("2036-01-01"),
        color = "Fin de aguas continentales"
      ),
      linetype = "dashed",
      linewidth = 0.15,
      alpha = 0.5,
    ) +
    geom_line(linewidth = 0.15, linetype = "solid") +
    labs(
      x = NULL,
      y = "Flujo [l/s]",
      color = "Estrategia desalación:"
    ) +
    scale_x_date(
      date_breaks = "3 years",
      date_labels = "%Y",
      limits = c(as.Date("2026-01-01"), as.Date("2053-01-01")),
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      expand = c(0, 0),
      limits = c(0, 1250, by = 250)
    ) +
    theme_minimal() +
    theme(
      panel.spacing.x = unit(0.5, "cm"),
      panel.spacing.y = unit(0.1, "cm"),
      axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
      legend.title = element_text(size = 8),
      legend.position = "bottom",
      legend.justification = c(0.5, 0),
      legend.margin = margin(0, 0, 0, 0),
      legend.direction = "horizontal",
      text = element_text(size = 8),
      panel.border = element_rect(
        colour = "black",
        linewidth = 0.1,
        fill = NA
      )
    )

  ggsave(
    filename = paste0(path_out, ".png"),
    width = 15,
    height = 10,
    units = "cm",
    dpi = 300
  )
}
