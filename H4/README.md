# Homework 4 

## Estructura del Proyecto

El proyecto está organizado en las siguientes carpetas:

-   `data/`: Contiene los conjuntos de datos utilizados en los análisis.
    -   `depresion_clean.csv`: Ejemplo de datos limpios.
    -   `depresion.xlsx - Sheet1.csv`: Datos originales.
-   `src/`: Contiene el código fuente de las funciones principales.
    -   `src/data/`: Funciones para el procesamiento y manipulación de datos.
        -   `gather_matrix.m`: Función para recolectar variables en una matriz.
        -   `load_data.m`: Función para cargar datos.
        -   `load_json.m`: Función para cargar archivos JSON de configuración.
        -   `normalize_matrix.m`: Función para normalizar matrices.
        -   `to_matrix.m`: Función para convertir datos a formato de matriz.
    -   `src/models/`: Implementaciones de modelos econométricos.
        -   `ols.m`: Implementación de Mínimos Cuadrados Ordinarios (OLS).
        -   `twosls.m`: Implementación de Mínimos Cuadrados en Dos Etapas (2SLS).
        -   `loglikelihood.m`: Contiene funciones relacionadas con la verosimilitud.
        -   `probit.m`: Contiene una implementación del modelo Probit).
-   `presentation/`: Contiene scripts de ejemplo o para ejecutar análisis específicos.
    -   `main.m`: Probablemente el script principal para ejecutar los modelos.
    -   `p2.m`: Otro script de análisis.
    -   `config/`: Archivos de configuración para los análisis.
        -   `p1.json`: Configuración para `main.m`.
        -   `p2.json`: Configuración para `p2.m`.
    -   `clean_data.ipynb`: Un notebook de Jupyter para la limpieza de datos.
-   `enunciado.pdf`: Documento con la descripción del problema.

## Requisitos

-   MATLAB (versión R2018a o superior recomendada).

## Cómo Usar

1.  **Clonar el Repositorio:**
    ```bash
    git clone [https://github.com/TuUsuario/NombreDeTuRepositorio.git](https://github.com/TuUsuario/NombreDeTuRepositorio.git)
    cd NombreDeTuRepositorio
    ```
2.  **Abrir en MATLAB:** Abre la carpeta principal del proyecto (`NombreDeTuRepositorio`) en MATLAB.
3.  **Configuración de Rutas:** Asegúrate de que las subcarpetas `src/models/` y `src/data/` estén en la ruta de MATLAB. Puedes hacerlo con `addpath('src/models')` y `addpath('src/data')` desde la carpeta raíz del proyecto, o añadiéndolas permanentemente desde el entorno de MATLAB.
4.  **Ejecutar Análisis:**
    * Para ejecutar el análisis principal, puedes usar el script `main.m` ubicado en la carpeta `presentation/`.
        ```matlab
        run('presentation/main.m');
        ```
    * Revisa los archivos `.json` en `presentation/config/` para entender las configuraciones de las variables y modelos.



