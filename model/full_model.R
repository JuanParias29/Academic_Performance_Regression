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

# --------------------------------------------------------------------

set.seed(123)
n <- nrow(df)
n_train <- floor(0.7 * n)
indices_train <- sample(seq_len(n), size = n_train)
train_df <- df[indices_train, ]
test_df  <- df[-indices_train, ]

# =============================
# MODELO COMPLETO
# =============================
modelo_completo <- lm(exam_score ~ age + gender + study_hours_per_day +
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