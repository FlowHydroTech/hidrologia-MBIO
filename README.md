# Repositorio dedicado hidrologia-MBIO

![fig0](./03_docs/01_figuras/otros/Logo_Flow_transp.png)

Este repositorio contiene código diseñado para postprocesar datos generados por simulaciones en GoldSim, con el objetivo de visualizar resultados mediante gráficos. El enfoque principal está en extraer, transformar y representar variables clave del modelo, facilitando el análisis y la comunicación de resultados de manera eficiente.

El código se estructura de una manera “modular”, lo que en programación significa que cada módulo o script es independiente y se enfoca en una tarea especifica, esto tiene algunos beneficios cómo:

1.	Facilidad de uso: En vez de tener un solo código de 1000 líneas, se divide el código en pequeños módulos, lo que facilita la depuración del código.
2.	Reutilizable: Si se desea crear un nuevo código que ocupe los anteriores puede hacerse de manera natural.
3.	Fácil mantención en el tiempo: Permite a un equipo de trabajar en distintos módulos mejorando la capacidad del programa. 

## Organización

La organización del código se hace en las siguientes carpetas:

- __00_dependencias__ es la carpeta en la cual se almacenan las distintas funciones del código.
- __01_input__ es la carpeta en la cual se guardan los archivos excel o de texto que contienen la información a procesar.
- __02_output__ es la carpeta en la cual se guardan los archivos generado por las rutinas.
- __03_docs__ es la carpeta dedicada exclusivamente a guardar imagenes o textos para la documentación del código.


## Módulos "procesarXX"

Los módulos "procesarXX" (ej: procesar01_est_daily.R) son los puntos de acceso a las distintas rutinas, cada archivo "procesarXX" se encarga de una tarea especifica, a continuación se detalla que hace cada archivo de forma individual.

1. **procesar01_est_daily.R**

 El script lee datos diarios desde un archivo Excel con los percentiles (generados con GoldSim) y generar un gráfico de series de tiempo diarios hasta el 31 de diciembre de 2052. Luego guarda la figura como imagen .png en una carpeta de salida. Para gráficar se muestra el resultado de procesar los datos de volumen del Tranque Mauro a nivel diario:


__Volumen Tranque Mauro Estocástico:__<br /> ![fig1 EST daily](./03_docs/01_figuras/figuras_volumen/E2c_5YPEX95_EST.png)

2. **procesar02_det_daily.R**

El script procesa datos de distintos escenarios determinísticos en una sola figura. Por ejemplo, tenemos el gráfico del volumen del Tranque Mauro para tres escenarios determinísticos a nivel diario: 

>[!NOTE] 
> También sirve para 1 escenario determinístico. Además si bien menciona que es a nivel diario, con un pequeño cambio en el código se puede procesar datos a nivel mensual y anual.

__Volumen Tranque Mauro Determinístico:__<br /> ![fig2 DET daily](./03_docs/01_figuras/figuras_volumen/volumen_laguna_DET_ALL.png)

3. **procesar03_est_yearly.R**

El script procesa datos de escenarios estocásticos a nivel anual. A continuación se muestran dos ejemplos, el primer ejemplo es el déficit de agua en la planta de tratamiento y el segundo es el flujo que aporta las plantas desaladoras al tratamiento de mineral.  

__Déficit de Agua:__<br /> ![fig3 EST def yearly](./03_docs/01_figuras/otros/deficit_E2c_5YPEX95_EST.png)
__Flujo de planta desaladora al tratamiento de mineral:__<br /> ![fig4 EST desaladora inflow yearly](./03_docs/01_figuras/otros/PPlant_from_desaladora_inflow_E2c_5YPEX95_EST.png)

4. **procesar04_directriz_AMSA.R**

Este script procesa datos mensuales de la variable de tratamiento de mineral de las 100 realizaciones de una simulación estocástica. Se establece que una configuración del modelo —definida por una combinación específica de condiciones hidrológicas, estrategia de desalación, y parámetros operacionales— garantiza seguridad hídrica cuando, al menos el 90% del tiempo, se logra una producción de agua suficiente para alcanzar o superar el 100% del requerimiento hídrico asociado al mineral proyectado. Esto implica que el sistema posee la resiliencia necesaria para enfrentar variabilidades climáticas sin comprometer la continuidad operativa ni la eficiencia en la producción. 

__Directriz AMSA:__<br /> ![fig5 AMSA](./03_docs/01_figuras/figuras_seguridad_hidrica/plot_AMSA_2026_2052_E2c_5YPEX85_EST.png)

5. **procesar05_archivos_txtGoldsim.R**

Este script procesa los archivos de .txt de GoldSim. En la última versión del código esto permite rellenar las planillas (./00_dependencias/template_excel) como Resultados_anual.xlsx y Resultados_ICMM.xlsx para escenarios determinísticos, los cuales vienen de un modelo de GoldSim (.gsm) que contiene todos los escenarios determinísticos simulados.

>[!NOTE]
> Para correr múltiples realizaciones de una simulación en el mismo escenario determinístico se deben modificar las dos variables estocásticas del modelo -la precipitación y la temperatura-.

6. **procesar06_desalacionMax.R**

El script procesa las variables del modelo en GoldSim: Bombeo_Maximo_Des1y2, Bombeo_Maximo_Des_Mod_extra y Bombeo_Maximo_Des_Mod_evu, con el objetivo de mostrar la capacidad máxima de desalación del sistema. La imagen a continuación ilustra dicha capacidad máxima para cada una de estas variables (y del total).


__Desalación Máxima:__<br /> ![fig6 Desalacion Max](./03_docs/01_figuras/otros/desalacion_max.png)
