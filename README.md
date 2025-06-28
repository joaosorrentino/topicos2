🧠 Projeto G2 – Análise Estatística e Modelagem Preditiva com Aplicação Web em Shiny

📌 Descrição do Projeto
Este projeto tem como objetivo analisar um conjunto de dados de um sistema orientado a objetos (KC1) utilizando R, aplicar técnicas de estatística descritiva e inferencial, construir um modelo de regressão linear para prever defeitos em classes de software e disponibilizar essa previsão via API REST e aplicação web interativa com Shiny.

📁 Estrutura do Projeto
graphql
Copiar
Editar
topicos2/
├── api/
│   └── plumber.R           # Código da API REST com modelo de regressão
├── app/
│   └── app.R               # Aplicação web construída com Shiny
├── analise/
│   └── analise_estatistica.R  # Código com análise descritiva, testes e modelo
├── dados/
│   └── dataset_KC1_classlevel_numdefect.xlsx
📊 Etapas Realizadas
1. Análise Estatística Descritiva
Média, mediana, moda, desvio padrão, mínimo, máximo e amplitude para cada variável numérica.

Histogramas com curvas de densidade.

Boxplots para identificação de outliers.

Teste de normalidade (Shapiro-Wilk).

2. Análise de Correlação
Matriz de correlação entre variáveis numéricas.

Identificação das variáveis mais correlacionadas com o número de defeitos (NUMDEFECTS).

Gráficos de dispersão com linha de tendência.

3. Regressão Linear
Modelo simples utilizando COUPLING_BETWEEN_OBJECTS como variável explicativa.

Avaliação dos coeficientes, R², R² ajustado, p-valores e diagnóstico dos resíduos.

4. API REST com Plumber
Implementação da API com o pacote plumber.

Endpoint que recebe a métrica como input e retorna a previsão de NUMDEFECTS.

5. Aplicação Shiny
Interface para inserir dados de entrada e visualizar a previsão.

Exibição dos gráficos usados na análise.

Aplicação publicada no shinyapps.io.

🚀 Como Executar Localmente
Pré-requisitos
R instalado (versão recomendada: 4.3+)

RStudio

Pacotes: readxl, tidyverse, ggpubr, PerformanceAnalytics, ggcorrplot, plumber, shiny

Passos
Clone o repositório:

bash
Copiar
Editar
git clone https://github.com/joaosorrentino/topicos2.git
Execute a análise estatística:

R
Copiar
Editar
source("analise/analise_estatistica.R")
Rode a API:

R
Copiar
Editar
library(plumber)
pr <- plumb("api/plumber.R")
pr$run(port = 8000)
Execute a aplicação Shiny:

R
Copiar
Editar
shiny::runApp("app")
🌐 Publicação
A aplicação está disponível em:

🔗 Link do ShinyApps.io
