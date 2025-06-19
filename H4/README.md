# Tarea 4: Econometria

Este repositorio contiene el código y los datos para la Tarea 4. 

El análisis se divide en dos partes principales:
1.  **Limpieza de Datos**: Se utiliza un Jupyter Notebook (`Python`) para procesar los datos iniciales.
2.  **Análisis Econométrico**: Se utilizan scripts de `MATLAB` para realizar las estimaciones de Mínimos Cuadrados Ordinarios (OLS), Mínimos Cuadrados en Dos Etapas (2SLS) y un modelo Probit.

## Estructura de Archivos
H4/
├── data/
│   ├── depresion.xlsx - Sheet1.csv  (Datos originales)
│   └── p1.csv                       (Datos limpios generados por Python)
├── presentation/
│   ├── clean_data.ipynb             (Notebook para limpieza de datos)
│   ├── p1.m                         (Script principal para OLS y 2SLS)
│   └── p2.m                         (Script principal para Probit)
├── utils/
│   ├── calculate_2sls.m
│   ├── calculate_ols.m
│   ├── load_data.m
│   └── probit_log_likelihood.m
├── enunciado.pdf
└── grupos.pdf

---

## 📜 Requisitos

Para ejecutar el código de este proyecto, necesitarás tener instalados `Python` y `MATLAB`.

### MATLAB

El código fue desarrollado y probado en **MATLAB R2024b**. Es posible que versiones más antiguas del software presenten problemas de compatibilidad con algunas de las funciones utilizadas.

### Python y Dependencias

Se utiliza Python para la limpieza inicial de los datos. Si no tienes Python instalado, puedes descargarlo desde [python.org](https://www.python.org/downloads/).

Se recomienda crear un entorno virtual para manejar las dependencias del proyecto.

1.  **Crear y activar un entorno virtual (opcional pero recomendado):**
    ```bash
    # Navega a la carpeta del proyecto
    cd ruta/a/H4

    # Crea el entorno
    python -m venv venv

    # Activa el entorno
    # En Windows
    .\venv\Scripts\activate
    # En macOS/Linux
    source venv/bin/activate
    ```

2.  **Instalar las dependencias:**
    Las librerías necesarias se pueden instalar usando `pip`.
    ```bash
    pip install pandas jupyterlab
    ```
    - **pandas**: Para la manipulación y limpieza de datos.
    - **jupyterlab**: Para poder ejecutar el notebook `.ipynb`.

---

## 🚀 Cómo Ejecutar el Código

Sigue estos pasos en orden para replicar los resultados:

1.  **Limpiar los Datos (Python)**:
    * Navega a la carpeta `presentation/` y abre el notebook `clean_data.ipynb`.
    * Ejecuta todas las celdas del notebook. Esto leerá el archivo `depresion.xlsx - Sheet1.csv` de la carpeta `data/` y generará el archivo `p1.csv` en la misma carpeta.


---
