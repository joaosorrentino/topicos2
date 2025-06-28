# 📊 Projeto G2 – Análise Estatística e Modelagem Preditiva com Shiny e API REST

Este projeto foi desenvolvido para a disciplina de **Tópicos Especiais 2**, e tem como objetivo analisar dados de qualidade de software utilizando R, construir um modelo preditivo de regressão linear e integrar uma API com uma aplicação interativa via Shiny.

---

## 📁 Estrutura do Projeto
```bash
topicos2/
├── analise/
│ └── analise_estatistica.R # Script com análises estatísticas e modelo
├── api/
│ └── plumber.R # API REST com modelo preditivo
├── app/
│ └── app.R # Aplicação Shiny interativa
├── dados/
│ └── dataset_KC1_classlevel_numdefect.xlsx # Base de dados
bash´´´


---

## 📌 Objetivos

- Realizar estatísticas descritivas (média, mediana, desvio padrão, etc.).
- Testar normalidade com Shapiro-Wilk.
- Avaliar correlações entre variáveis.
- Construir modelo de regressão linear para prever defeitos (`NUMDEFECTS`).
- Criar uma **API REST** para servir esse modelo.
- Desenvolver uma **aplicação Shiny** para interação com o usuário.
- Publicar a aplicação no [shinyapps.io](https://www.shinyapps.io).

---

## 🔧 Como Executar o Projeto

### 1. Clone o Repositório

```bash
git clone https://github.com/seuusuario/seurepositorio.git
cd seurepositorio/topicos2


source("analise/analise_estatistica.R")

Este script realiza:

Estatísticas descritivas

Histogramas e boxplots

Testes de normalidade

Regressão linear

Diagnóstico de resíduos

Rodando a API com plumber

library(plumber)
pr <- plumb("api/plumber.R")
pr$run(port = 8000)

http://localhost:8000/predict?DEPENDENCY_LEVEL=1.25

Executar a Aplicação Shiny

shiny::runApp("app")
