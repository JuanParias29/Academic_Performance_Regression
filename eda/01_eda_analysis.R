# Cargar paquetes
library(readxl)
library(ggplot2)
library(corrplot)

# Leer los datos
df <- read_excel("data/student_habits_performance.xlsx")

# Convertir a factor las variables categóricas

df$gender <- factor(df$gender)
df$part_time_job <- factor(df$part_time_job)
df$diet_quality <- factor(df$diet_quality)
df$parental_education_level <- factor(df$parental_education_level)
df$internet_quality <- factor(df$internet_quality)
df$extracurricular_participation <- factor(df$extracurricular_participation)

# Estructura del conjunto de datos
str(df)

# Cantidad de nulos por variable
colSums(is.na(df))

# Vector con las variables numéricas explicativas
num_vars <- c("age", "study_hours_per_day", "social_media_hours", "netflix_hours",
              "attendance_percentage", "sleep_hours", "exercise_frequency",
              "mental_health_rating")

# Diccionario de etiquetas en español
etiquetas <- list(
  age = "Edad",
  study_hours_per_day = "Horas de estudio por día",
  social_media_hours = "Horas en redes sociales",
  netflix_hours = "Horas en Netflix",
  attendance_percentage = "Porcentaje de asistencia",
  sleep_hours = "Horas de sueño",
  exercise_frequency = "Frecuencia de ejercicio",
  mental_health_rating = "Nivel de salud mental",
  exam_score = "Puntaje del examen"
)

# Iterar sobre cada variable y graficar dispersión
for (var in num_vars) {
  p <- ggplot(df, aes_string(x = var, y = "exam_score")) +
    geom_point(alpha = 0.6, color = "steelblue") +
    labs(
      title = paste("Puntaje del examen vs", etiquetas[[var]]),
      x = etiquetas[[var]],
      y = etiquetas[["exam_score"]]
    ) +
    theme_minimal()
  
  print(p)
}


# 1) Selección de variables numéricas
num_df <- df[, c("age", "study_hours_per_day", "social_media_hours", 
                 "netflix_hours", "attendance_percentage", 
                 "sleep_hours", "exercise_frequency",
                 "mental_health_rating", "exam_score")]

# 2) Matriz de correlación
cor_matrix <- cor(num_df, use = "complete.obs")

# 3) Gráfico de correlación
corrplot(cor_matrix, method = "color", type = "upper", 
         addCoef.col = "black", tl.cex = 0.8,
         title = "Matriz de correlación (variables numéricas)",
         mar = c(0,0,2,0))



# ================================
# 2) Correlación con categóricas
# ================================
# Crear dummies
df_dummies <- model.matrix(~ gender + part_time_job + diet_quality +
                             parental_education_level + internet_quality +
                             extracurricular_participation - 1, data = df)
df_dummies <- as.data.frame(df_dummies)

# Correlación de cada dummy con exam_score
cor_with_score <- cor(df_dummies, df$exam_score)
print(round(cor_with_score, 3))

# ================================
# 3) ANOVA para categóricas
# ================================
cat_vars <- c("gender", "part_time_job", "diet_quality",
              "parental_education_level", "internet_quality",
              "extracurricular_participation")

anova_results <- lapply(cat_vars, function(var) {
  mod <- aov(as.formula(paste("exam_score ~", var)), data = df)
  summary(mod)
})
names(anova_results) <- cat_vars
anova_results


# Cargar librería para mostrar como tabla bonita (opcional)
# install.packages("knitr") # Solo si no está instalada
library(knitr)

cat_vars <- c("gender", "part_time_job", "diet_quality",
              "parental_education_level", "internet_quality",
              "extracurricular_participation")

# Crear un resumen de ANOVA para cada variable categórica
anova_summary_df <- do.call(rbind, lapply(cat_vars, function(var) {
  mod <- aov(as.formula(paste("exam_score ~", var)), data = df)
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