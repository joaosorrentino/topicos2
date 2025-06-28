library(readxl)
library(tidyverse)
library(ggpubr)
library(PerformanceAnalytics)
library(ggcorrplot)
library(plumber)

# 📥 Importação dos dados
dados_brutos <- read_excel("dataset_KC1_classlevel_numdefect.xlsx")

# Renomeando colunas-chave para variar
dados <- dados_brutos %>%
  rename(
    BUG_TOTAL = NUMDEFECTS,
    DEPENDENCY_LEVEL = COUPLING_BETWEEN_OBJECTS
  )

# 📊 Medidas Resumidas
estatisticas_resumo <- dados %>%
  summarise(across(where(is.numeric), list(
    media = ~mean(., na.rm = TRUE),
    mediana = ~median(., na.rm = TRUE),
    desv_padrao = ~sd(., na.rm = TRUE),
    min = ~min(., na.rm = TRUE),
    max = ~max(., na.rm = TRUE),
    intervalo = ~max(., na.rm = TRUE) - min(., na.rm = TRUE)
  )))

print(estatisticas_resumo)

# 📈 Moda das variáveis numéricas
calcula_moda <- function(x) {
  valores <- unique(x)
  valores[which.max(tabulate(match(x, valores)))]
}

modas <- map_df(dados %>% select(where(is.numeric)), ~ tibble(moda = calcula_moda(.)))
print(modas)

# 📉 Distribuições das variáveis
grafico_hist <- dados %>%
  pivot_longer(cols = where(is.numeric)) %>%
  ggplot(aes(x = value)) +
  geom_histogram(aes(y = ..density..), fill = "lightcoral", bins = 25, alpha = 0.6) +
  geom_density(color = "darkblue", linewidth = 1) +
  facet_wrap(~name, scales = "free") +
  theme_light() +
  labs(title = "Distribuições com Densidade")

print(grafico_hist)

# 🧊 Visualização de outliers
grafico_box <- dados %>%
  pivot_longer(cols = where(is.numeric)) %>%
  ggplot(aes(y = value)) +
  geom_boxplot(fill = "steelblue", alpha = 0.6) +
  facet_wrap(~name, scales = "free") +
  theme_light() +
  labs(title = "Boxplots das Variáveis")

print(grafico_box)

# 📐 Verificando Normalidade (teste de Shapiro-Wilk)
teste_normalidade <- map_dbl(dados %>% select(where(is.numeric)), ~ shapiro.test(.)$p.value)
print(teste_normalidade)

# 🔗 Correlação entre variáveis
matriz_cor <- cor(dados %>% select(where(is.numeric)), use = "complete.obs")
grafico_cor <- ggcorrplot(matriz_cor, lab = TRUE, colors = c("darkred", "white", "darkgreen"))
print(grafico_cor)

# 📏 Modelo de Regressão Linear
modelo_simples <- lm(BUG_TOTAL ~ DEPENDENCY_LEVEL, data = dados)
print(summary(modelo_simples))

# 🧪 Análise dos Resíduos
par(mfrow = c(2, 2))
plot(modelo_simples)
