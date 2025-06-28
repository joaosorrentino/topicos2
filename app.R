library(shiny)
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(PerformanceAnalytics)
library(readxl)
library(ggcorrplot)

# ---- Dados ----
load("dados.RData")

# Renomeando colunas para tornar o código distinto
dados <- dados %>%
  rename(
    DEPENDENCY_METRIC = COUPLING_BETWEEN_OBJECTS,
    BUG_COUNT = NUMDEFECTS
  )

# ---- Modelo ----
modelo_regressao <- lm(BUG_COUNT ~ DEPENDENCY_METRIC, data = dados)

# ---- Gráficos ----

# Histograma com densidade
grafico_hist <- dados %>%
  pivot_longer(cols = where(is.numeric)) %>%
  ggplot(aes(x = value)) +
  geom_histogram(aes(y = ..density..), bins = 25, fill = "lightgreen", alpha = 0.5) +
  geom_density(color = "darkgreen", size = 1) +
  facet_wrap(~name, scales = "free") +
  theme_minimal()

# Boxplot
grafico_caixa <- dados %>%
  pivot_longer(cols = where(is.numeric)) %>%
  ggplot(aes(y = value)) +
  geom_boxplot(fill = "purple", alpha = 0.6) +
  facet_wrap(~name, scales = "free") +
  theme_minimal()

# Dispersão com regressão linear
grafico_regressao <- ggplot(dados, aes(x = DEPENDENCY_METRIC, y = BUG_COUNT)) +
  geom_point(color = "darkred") +
  geom_smooth(method = "lm", se = TRUE, color = "black") +
  theme_minimal()

# Matriz de correlação
matriz_correlacao <- cor(dados %>% select(where(is.numeric)), use = "complete.obs")
grafico_matriz <- ggcorrplot(matriz_correlacao, lab = TRUE, colors = c("orange", "white", "darkblue"))

# Novo: gráfico de barras com médias
grafico_medias <- dados %>%
  summarise(across(where(is.numeric), mean, na.rm = TRUE)) %>%
  pivot_longer(cols = everything()) %>%
  ggplot(aes(x = name, y = value, fill = name)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Média das Variáveis", x = "", y = "Valor Médio") +
  theme(legend.position = "none")

# ---- Interface ----
ui <- fluidPage(
  titlePanel("Estimativa de Bugs com Base em Métricas de Dependência"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("dependencia", "Digite o valor da métrica de dependência:", value = 0),
      actionButton("calcular", "Estimar BUG_COUNT"),
      hr(),
      h4("Escolha um gráfico para exibir:"),
      selectInput("tipo_grafico", "Visualização:",
                  choices = c("Histograma", "Boxplot", "Dispersão", "Correlação", "Médias"))
    ),
    
    mainPanel(
      h3("Resultado da Estimativa:"),
      verbatimTextOutput("saida_predicao"),
      
      h3("Visualização Selecionada:"),
      plotOutput("saida_grafico")
    )
  )
)

# ---- Servidor ----
server <- function(input, output) {
  # Estimativa baseada no modelo
  observeEvent(input$calcular, {
    previsao <- predict(modelo_regressao, newdata = data.frame(DEPENDENCY_METRIC = input$dependencia))
    output$saida_predicao <- renderPrint({
      paste("Valor estimado de BUG_COUNT:", round(previsao, 2))
    })
  })
  
  # Exibição dos gráficos
  output$saida_grafico <- renderPlot({
    switch(input$tipo_grafico,
           "Histograma" = grafico_hist,
           "Boxplot" = grafico_caixa,
           "Dispersão" = grafico_regressao,
           "Correlação" = grafico_matriz,
           "Médias" = grafico_medias)
  })
}

# ---- Execução da aplicação ----
shinyApp(ui = ui, server = server)
