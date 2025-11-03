# Repositorio dedicado hidrologia-MBIO

![fig0](./03_docs/01_figuras/otros/Logo_Flow_transp.png)

El código se estructura de una manera “modular”, lo que en programación significa que cada módulo o script es independiente y se enfoca en una tarea especifica, esto tiene algunos beneficios cómo:
1.	Facilidad de uso: En vez de tener un solo código de 1000 líneas, se divide el código en pequeños módulos, lo que facilita la depuración del código.
2.	Reutilizable: Si se desea crear un nuevo código que ocupe los anteriores puede hacerse de manera natural.
3.	Fácil mantención en el tiempo: Permite a un equipo de trabajar en distintos módulos mejorando la capacidad del programa. 

## Modulos "Procesar"

Los módulos "Procesar" (ej: procesar01_est_daily.R) son los puntos de acceso a las distintas rutinas, cada archivo "procesarXX" se encarga de una tarea especifica, a continuación se detalla que hace cada archivo de forma individual.

1. **procesar01_est_daily.R**

El script lee datos diarios desde un archivo Excel con los percentiles (generados con GoldSim) y generar un gráfico de series de tiempo diarios hasta el 31 de diciembre de 2052. Luego guarda la figura como imagen .png en una carpeta de salida.

![fig1 EST daily](./03_docs/01_figuras/figuras_volumen/E2c_5YPEX95_EST.png)

2. **procesar02_det_daily.R**

![fig2 DET daily](./03_docs/01_figuras/figuras_volumen/volumen_laguna_DET_ALL.png)

3. **procesar03_est_yearly.R**

![fig3 EST def yearly](./03_docs/01_figuras/otros/deficit_E2c_5YPEX95_EST.png)
![fig4 EST desaladora inflow yearly](./03_docs/01_figuras/otros/PPlant_from_desaladora_inflow_E2c_5YPEX95_EST.png)

4. **procesar04_directriz_AMSA.R**

![fig5 AMSA](./03_docs/01_figuras/figuras_seguridad_hidrica/plot_AMSA_2026_2052_E2c_5YPEX85_EST.png)

5. **procesar05_archivos_txtGoldsim.R**

6. **procesar06_desalacionMax.R**

![fig6 Desalacion Max](./03_docs/01_figuras/otros/desalacion_max.png)
