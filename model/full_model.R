# ------------------------- Cargar paquetes ------------------------------------
library(readxl)
library(ggplot2)
library(car)
library(lmtest)
library(nortest)
require(zoo)
library(MASS)

# --------------------------- Cargar datos -------------------------------------
df <- read_excel("data/student_habits_performance.xlsx")

# Nuevos nombres
nuevos_nombres <- c("ID_Alumno", "Edad", "Genero", "Horas_Estudio", "Redes_Sociales", 
                    "Netflix", "Trabajo", "Asistencia", "Horas_Sueño", 
                    "Calidad_Dieta", "Frecuencia_Ejercicio", "Educacion_Parental", 
                    "Calidad_Internet", "Salud_Mental", "Act_Extraescolar", "Puntaje_Examen")
colnames(df) <- nuevos_nombres

# --------------------------- Factores -------------------------------------
df$Genero <- factor(df$Genero)
df$Trabajo <- factor(df$Trabajo)
df$Calidad_Dieta <- factor(df$Calidad_Dieta)
df$Educacion_Parental <- factor(df$Educacion_Parental)
df$Calidad_Internet <- factor(df$Calidad_Internet)
df$Act_Extraescolar <- factor(df$Act_Extraescolar)

# ------------------------- Estimación de modelos ------------------------------

# Modelo base completo (variables originales)
Mod_Completo <- lm(Puntaje_Examen ~ Edad + Genero + Horas_Estudio +
                     Redes_Sociales + Netflix + Trabajo + Asistencia +
                     Horas_Sueño + Calidad_Dieta + Frecuencia_Ejercicio +
                     Educacion_Parental + Calidad_Internet + Salud_Mental +
                     Act_Extraescolar,
                   data = df)

# Nueva variable Tiempo_Pantalla
df$Tiempo_Pantalla <- df$Redes_Sociales + df$Netflix

# Modelo extendido (con transformaciones)
Mod_Comp_Transformado <- lm(Puntaje_Examen ~ Edad + Genero + Horas_Estudio + I(Horas_Estudio^2) +
                              Tiempo_Pantalla + Asistencia + I(Asistencia^2) +
                              Horas_Sueño + I(Horas_Sueño^2) +
                              Frecuencia_Ejercicio * Salud_Mental +
                              Calidad_Dieta + Educacion_Parental +
                              Calidad_Internet + Act_Extraescolar + Trabajo,
                            data = df)

# ------------------ Comparación de modelos base vs extendido ------------------

# Función de comparación sin funciones personalizadas
comparar_modelos <- function(modelo, nombre){
  res <- residuals(modelo)
  data.frame(
    Modelo = nombre,
    AIC = AIC(modelo),
    R2 = summary(modelo)$r.squared,
    R2_Ajustado = summary(modelo)$adj.r.squared,
    RMSE = sqrt(mean(res^2))
  )
}

# Comparar modelos
resultados <- rbind(
  comparar_modelos(Mod_Completo, "Mod_Completo"),
  comparar_modelos(Mod_Comp_Transformado,  "Mod_Comp_Transformado")
)
print(resultados)

# ------------------ Pruebas de hipótesis --------------------

# Global: F-test (ANOVA)
anova(Mod_Comp_Transformado)

# Individual: t-test
summary(Mod_Comp_Transformado)

# ------------------ Reducción de modelo usando stepAIC ------------------------
Mod_Transformado_Reducido  <- stepAIC(Mod_Comp_Transformado, direction = "both", trace = FALSE)

# ------------------ Comparación de modelos final ------------------------------
resultados <- rbind(
  comparar_modelos(Mod_Completo, "Mod_Completo"),
  comparar_modelos(Mod_Comp_Transformado,  "Mod_Comp_Transformado"),
  comparar_modelos(Mod_Transformado_Reducido,  "Mod_Transformado_Reducido")
)
print(resultados)

# ------------------ Validación de supuestos -----------------------------------

# Normalidad de los residuos
shapiro.test(residuals(Mod_Transformado_Reducido))   # Shapiro-Wilk
ad.test(residuals(Mod_Transformado_Reducido))        # Anderson-Darling
lillie.test(residuals(Mod_Transformado_Reducido))    # Kolmogorov-Smirnov (Lilliefors)
qqnorm(residuals(Mod_Transformado_Reducido)); qqline(residuals(Mod_Transformado_Reducido), col = 2)

# Homocedasticidad
bptest(Mod_Transformado_Reducido)
ncvTest(Mod_Transformado_Reducido)
plot(Mod_Transformado_Reducido$fitted.values, residuals(Mod_Transformado_Reducido),
     main="Residuos vs Ajustados", xlab="Valores ajustados", ylab="Residuos")
abline(h = 0, col="red")

# Independencia de errores
dwtest(Mod_Transformado_Reducido)
acf(residuals(Mod_Transformado_Reducido), main="ACF de los residuos")

# Multicolinealidad
vif(Mod_Transformado_Reducido)

# Observaciones influyentes
plot(cooks.distance(Mod_Transformado_Reducido), type="h", main="Distancia de Cook")
abline(h = 4/nrow(df), col="red", lty=2)
influencePlot(Mod_Transformado_Reducido, id.method="identify", main="Puntos influyentes")


# ---------------- Modelo seleccionado ---------------
summary(Mod_Transformado_Reducido)

