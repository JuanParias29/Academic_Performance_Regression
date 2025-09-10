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

# =============================
# MODELO REDUCIDO
# =============================
modelo_reducido <- lm(exam_score ~ study_hours_per_day +
                        social_media_hours + netflix_hours + 
                        attendance_percentage + sleep_hours + diet_quality +
                        exercise_frequency + mental_health_rating,
                      data = train_df)

summary(modelo_reducido)

# Predicciones
pred_test_reducido <- predict(modelo_reducido, newdata = test_df)

# Evaluación
mse_reducido <- mean((test_df$exam_score - pred_test_reducido)^2)
rmse_reducido <- sqrt(mse_reducido)
r2_reducido <- 1 - sum((test_df$exam_score - pred_test_reducido)^2) / 
  sum((test_df$exam_score - mean(test_df$exam_score))^2)

# R² ajustado manual
p_reducido <- length(modelo_reducido$coefficients) - 1
r2_adj_reducido <- 1 - (1 - r2_reducido) * ((n_test - 1) / (n_test - p_reducido - 1))

cat("\n--- Modelo Reducido ---\n")
cat("MSE:", mse_reducido, "\n")
cat("RMSE:", rmse_reducido, "\n")
cat("R²:", r2_reducido, "\n")
cat("R² ajustado:", r2_adj_reducido, "\n")


# =============================
# COMPARATIVA FINAL
# =============================
comparativa <- data.frame(
  Métrica = c("MSE", "RMSE", "R²", "R² ajustado"),
  Modelo_Completo = c(mse_completo, rmse_completo, r2_completo, r2_adj_completo),
  Modelo_Reducido = c(mse_reducido, rmse_reducido, r2_reducido, r2_adj_reducido)
)

cat("\n--- Comparativa de Métricas ---\n")
print(comparativa, row.names = FALSE)

