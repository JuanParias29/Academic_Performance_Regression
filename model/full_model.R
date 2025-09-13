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

# ---------------------------- MODELO COMPLETO ---------------------------------

full_model <- lm(exam_score ~ age + gender + study_hours_per_day +
                        social_media_hours + netflix_hours + part_time_job +
                        attendance_percentage + sleep_hours + diet_quality +
                        exercise_frequency + parental_education_level +
                        internet_quality + mental_health_rating +
                        extracurricular_participation,
                      data = train_df)

summary(modelo_completo)

# Predicciones
pred_test_completo <- predict(modelo_completo, newdata = test_df)

# Evaluación
mse_completo <- mean((test_df$exam_score - pred_test_completo)^2)
rmse_completo <- sqrt(mse_completo)
r2_completo <- 1 - sum((test_df$exam_score - pred_test_completo)^2) / 
  sum((test_df$exam_score - mean(test_df$exam_score))^2)

# R² ajustado manual
n_test <- nrow(test_df)
p_completo <- length(modelo_completo$coefficients) - 1
r2_adj_completo <- 1 - (1 - r2_completo) * ((n_test - 1) / (n_test - p_completo - 1))

cat("\n--- Modelo Completo ---\n")
cat("MSE:", mse_completo, "\n")
cat("RMSE:", rmse_completo, "\n")
cat("R²:", r2_completo, "\n")
cat("R² ajustado:", r2_adj_completo, "\n")