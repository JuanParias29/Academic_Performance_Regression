# Cargar paquetes
library(readxl)
library(ggplot2)
library(corrplot)

# Leer los datos
df <- read_excel("data/student_habits_performance.xlsx")

# Nuevos nombres para las columnas
nuevos_nombres <- c("ID_Alumno", "Edad", "Genero", "Horas_Estudio", "Redes_Sociales", 
                    "Netflix", "Trabajo", "Asistencia", "Horas_Sueño", 
                    "Calidad_Dieta", "Frecuencia_Ejercicio", "Educacion_Parental", 
                    "Calidad_Internet", "Salud_Mental", "Act_Extraescolar", "Puntaje_Examen")

# Cambiar los nombres de las columnas
colnames(df) <- nuevos_nombres

# Convertir a factor las variables categóricas
df$Genero <- factor(df$Genero)
df$Trabajo <- factor(df$Trabajo)
df$Calidad_Dieta <- factor(df$Calidad_Dieta)
df$Nivel_Educacion_Parental <- factor(df$Educacion_Parental)
df$Calidad_Internet <- factor(df$Calidad_Internet)
df$Act_Extraescolar <- factor(df$Act_Extraescolar)

#-------------------- EDA ------------------------

# Estructura del conjunto de datos
str(df)

# Resumen estadístico
summary(df)

# Cantidad de nulos por variable
colSums(is.na(df))

# Vector con las variables numéricas explicativas
num_vars <- df[, c("Edad", "Horas_Estudio", "Redes_Sociales", 
                   "Netflix", "Asistencia", "Horas_Sueño", 
                   "Frecuencia_Ejercicio", "Salud_Mental", "Puntaje_Examen")]

# Diccionario de etiquetas
etiquetas <- list(
  Edad = "Edad",
  Horas_Estudio = "Horas de estudio por día",
  Redes_Sociales = "Horas en redes sociales",
  Netflix = "Horas en Netflix",
  Asistencia = "Porcentaje de asistencia",
  Horas_Sueño = "Horas de sueño",
  Frecuencia_Ejercicio = "Frecuencia de ejercicio",
  Salud_Mental = "Nivel de salud mental",
  Puntaje_Examen = "Puntaje del examen"
)

# Iterar sobre cada variable y graficar dispersión
for (var_name in names(num_vars)) {
  p <- ggplot(df, aes_string(x = var_name, y = "Puntaje_Examen")) +
    geom_point(alpha = 0.6, color = "steelblue") +
    labs(
      title = paste("Puntaje del examen vs", etiquetas[[var_name]]),
      x = etiquetas[[var_name]],
      y = etiquetas[["Puntaje_Examen"]]
    ) +
    theme_minimal()
  
  print(p)
}

#-------------------- Correlación Lineal Var. Numéricas ------------------------

# Calcular la matriz de correlación
cor_matrix <- cor(num_vars, use = "complete.obs")
cor_matrix_rounded <- round(cor_matrix, 2)

# Gráfico de correlación con etiquetas más cortas y ajustes adicionales
corrplot(cor_matrix_rounded, method = "color", type = "upper", 
         addCoef.col = "black", tl.cex = 0.8,
         title = "Matriz de correlación (variables numéricas)",
         mar = c(0, 0, 2, 0), 
         tl.labels = etiquetas[names(cor_matrix)],
         tl.col = "darkgray")

#-------------------- Correlacion Lineal Var. Categóricas ----------------------

# Crear dummies para las variables categóricas
df_dummies <- model.matrix(~ Genero + Trabajo + Calidad_Dieta +
                             Nivel_Educacion_Parental + Calidad_Internet +
                             Act_Extraescolar - 1, data = df)
df_dummies <- as.data.frame(df_dummies)

# Correlación de cada dummy con Puntaje_Examen
cor_with_score <- cor(df_dummies, df$Puntaje_Examen)
print(round(cor_with_score, 3))

# ANOVA para variables categóricas

cat_vars <- c("Genero", "Trabajo", "Calidad_Dieta",
              "Nivel_Educacion_Parental", "Calidad_Internet",
              "Act_Extraescolar")

anova_results <- lapply(cat_vars, function(var) {
  mod <- aov(as.formula(paste("Puntaje_Examen ~", var)), data = df)
  summary(mod)
})
names(anova_results) <- cat_vars
anova_results

# Cargar librería para mostrar como tabla bonita (opcional)
# install.packages("knitr") # Solo si no está instalada
library(knitr)

# Crear un resumen de ANOVA para cada variable categórica
anova_summary_df <- do.call(rbind, lapply(cat_vars, function(var) {
  mod <- aov(as.formula(paste("Puntaje_Examen ~", var)), data = df)
  mod_summary <- summary(mod)[[1]]
  p_value <- mod_summary["Pr(>F)"][1]
  significance <- ifelse(p_value < 0.05, "Significativo", "No significativo")
  
  data.frame(
    Variable = var,
    `Valor p` = round(p_value, 4),
    Resultado = significance,
    check.names = FALSE
  )
}))

# Mostrar tabla en formato bonito
kable(anova_summary_df, caption = "Resultados ANOVA para variables categóricas")
