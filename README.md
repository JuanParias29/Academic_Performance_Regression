# 📊 Academic Performance Regression

Este proyecto consiste en un análisis de regresión lineal realizado en **RStudio**, con el objetivo de encontrar el mejor modelo posible para explicar el rendimiento académico de los estudiantes, cumpliendo con todos los supuestos estadísticos del modelo.

---

## 🎯 Objetivo

Estimar el mejor modelo de **regresión lineal** posible para predecir el rendimiento académico, asegurando el cumplimiento de los supuestos del modelo, la validez estadística de los parámetros y la calidad del ajuste.

---

## Estructura del análisis

El análisis se divide en dos partes principales:

### Parte 1: Análisis previo de los datos (20%)

- Análisis exploratorio de datos (EDA)
- Gráficos de dispersión entre:
  - La variable dependiente y las variables explicativas
  - Las variables explicativas entre sí
- Interpretación de relaciones observadas:
  - Identificación de relaciones lineales y no lineales
  - Evaluación de transformaciones de las variables

### Parte 2: Estimación de modelos, ajuste y validación (80%)

- Estimación del modelo completo con todas las variables
- Pruebas de hipótesis:
  - Significancia global del modelo
  - Significancia individual de los coeficientes
- Validación de supuestos del modelo:
  - Linealidad
  - Homocedasticidad
  - Independencia
  - Normalidad de residuos
- Reestimación del modelo:
  - Eliminación de variables no significativas
  - Comparación de bondad de ajuste (R², AIC, BIC, etc.)
- Interpretación detallada de los parámetros del modelo final

---

## 🧰 Herramientas utilizadas

- **Lenguaje:** R
- **IDE:** RStudio
- **Librerías principales:**
  - `ggplot2` – visualización
  - `car`, `lmtest` – pruebas estadísticas
  - `dplyr`, `tidyr` – manipulación de datos
  - `broom`, `performance` – validación de modelos

---

## 📁 Estructura del repositorio

```bash
academic-performance-regression/
│
├── data/
│   └── student_habits_performance.xlsx    # Conjunto de datos original
│   └── data_dictionary.xlsx               # Diccionario de datos
│
├── eda/
│   └── 01_eda_analysis.R                  # Análisis exploratorio de datos
│
├── model/
│   ├── full_model.R                       # Modelo completo
│   └── reduced_model.R                    # Modelo reducido
│
├── reports/
│   ├── reporte_1_AR.pdf                   # Primer informe del proyecto
│   └── ...                                # Informes adicionales
│
└── README.md                              # Documentación general del proyecto


```

## 👥 Data Scientists

- [Juan Pablo Arias](https://github.com/JuanParias29)
- Sergio Pardo Hurtado

---
## 📚 Análisis de Regresión
**Docente:** Gabriel Camilo Pérez
