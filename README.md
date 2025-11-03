# hidrologia-MBIO
Repositorio dedicado hidrologia-MBIO

El código se estructura de una manera “modular”, lo que en programación significa que cada módulo o script es independiente y se enfoca en una tarea especifica, esto tiene algunos beneficios cómo:
1.	Facilidad de uso: En vez de tener un solo código de 1000 líneas, se divide el código en pequeños módulos, lo que facilita la depuración del código.
2.	Reutilizable: Si se desea crear un nuevo código que ocupe los anteriores puede hacerse de manera natural.
3.	Fácil mantención en el tiempo: Permite a un equipo de trabajar en distintos módulos mejorando la capacidad del programa. 

## Modulos "Procesar"

Los módulos "Procesar" (ej: procesar01_est_daily.R) son los puntos de acceso a las distintas rutinas, cada archivo "procesarXX" se encarga de una tarea especifica, a continuación se detalla que hace cada archivo de forma individual.

1. **procesar01_est_daily.R**

Se encarga de gráficar la figura con los percentiles (p1 al p99) entregados con goldsim.  

![fig EST daily](./03_docs/01_figuras/figuras_volumen/E2c_5YPEX95_EST.png)

2. **procesar02_det_daily.R**

![fig DET daily](./03_docs/01_figuras/figuras_volumen/volumen_laguna_DET_ALL.png)

3. **procesar03_est_yearly.R**

![fig EST def yearly](./03_docs/01_figuras/otros/deficit_E2c_5YPEX95_EST.png)
![fig EST desaladora inflow yearly](./03_docs/01_figuras/otros/PPlant_from_desaladora_inflow_E2c_5YPEX95_EST.png)

3. **procesar04_directriz_AMSA.R**

![fig AMSA](./03_docs/01_figuras/figuras_seguridad_hidrica/plot_AMSA_2026_2052_E2c_5YPEX85_EST.png)

4. **procesar05_archivos_txtGoldsim.R**

5. **procesar06_desalacionMax.R**

![fig Desalacion Max](./03_docs/01_figuras/otros/desalacion_max.png)
