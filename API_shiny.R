# ============================================================
# APPLICATION : ANALYSE ET PRÉVISION DE L'INFLATION AU SÉNÉGAL
# ============================================================

library(shiny)
library(bs4Dash)
library(fresh)
library(ggplot2)
library(dplyr)
library(tsibble)
library(forecast)
library(ARDL)
library(dynlm)

# --- THÈME VIOLET
my_theme <- create_theme(
  bs4dash_vars(
    main_footer_bg = "#f4f6f9",
    sidebar_dark_bg = "#1f194c", 
    sidebar_dark_color = "#ced4da"
  ),
  bs4dash_color(
    blue = "#6f42c1" # Écrase le 'primary' par le violet
  )
)

# --- CHARGEMENT DES DONNÉES
setwd("D:/Hadidja/Econometrie")
data_ts      <- readRDS("data/data_ts.rds")
sarima_model <- readRDS("data/sarima_model.rds")
model_ardl   <- readRDS("data/ardl_model.rds")
forecast_df  <- readRDS("data/ml_plot_dt.rds") # Utilisé pour le graph de comparaison
metrics_df   <- readRDS("data/metrics_df.rds")  # Utilisé pour le tableau

# ============================================================
# UI (Interface Utilisateur)
# ============================================================
ui <- dashboardPage(
  freshTheme = my_theme,
  dark = NULL,
  header = dashboardHeader(title = dashboardBrand(title = "Sénégal Inflation", color = "primary")),
  
  sidebar = dashboardSidebar(
    id = "sidebar_id",
    sidebarMenu(
      menuItem("Accueil", tabName = "accueil", icon = icon("home")),
      menuItem("Données", tabName = "donnees", icon = icon("database")),
      menuItem("Comparaison", tabName = "comparaison", icon = icon("balance-scale")),
      menuItem("Prédictions", tabName = "predict", icon = icon("bolt")),
      menuItem("Modèle ARDL", tabName = "ardl", icon = icon("university"))
    )
  ),
  body = dashboardBody(
    # CSS Personnalisé pour arrondir les cartes
    tags$head(tags$style(HTML(".card { border-radius: 15px; border: none; }"))),
    
    tabItems(
      # --- Onglet Accueil
      tabItem(
        tabName = "accueil",
        div(style = "background: #6f42c1; color: white; border-radius: 15px; padding: 50px; text-align: center;",
            h1("Sénégal Carbon AI", style = "font-weight: bold;"),
            p("Planifiez l'avenir durable du Sénégal grâce à l'Intelligence Artificielle."),
            br(),
            actionButton("go_data", "Analyser les données", class = "btn-light btn-lg", style = "margin-right:10px; border-radius:25px;"),
            actionButton("go_pred", "Lancer une prédiction", class = "btn-outline-light btn-lg", style = "border-radius:25px;")
        ),
        br(),
        fluidRow(
          bs4Card(title = "Analyse Complète", width = 4, status = "primary", "Visualisation des indicateurs."),
          bs4Card(title = "Prévisions Précises", width = 4, status = "primary", "Modèles SARIMA et ARDL."),
          bs4Card(title = "Impact Économique", width = 4, status = "primary", "Aide à la décision.")
        )
      ),
      
      # 2. Données
      tabItem(tabName = "donnees",
              bs4Card(title = "Historique de l'Inflation", width = 12, status = "primary", tableOutput("data_head"))
      ),
      
      # 3. COMPARAISON DES MODÈLES (Celui que tu voulais !)
      tabItem(tabName = "comparaison",
              fluidRow(
                bs4Card(
                  title = "Performances des Modèles (Métriques)", width = 12, status = "primary",
                  tableOutput("metrics_table")
                ),
                bs4Card(
                  title = "Graphique : Inflation Réelle vs Prévisions", width = 12, status = "primary",
                  plotOutput("forecast_plot")
                )
              )
      ),
      
      # 4. Prédictions (SARIMA)
      tabItem(tabName = "predict",
              fluidRow(
                bs4Card(title = "Paramètres", width = 4, numericInput("h_val", "Horizon (mois) :", 12), status = "primary"),
                bs4Card(title = "Projection SARIMA", width = 8, plotOutput("sarima_plot"), status = "primary")
              )
      ),
      
      # 5. ARDL
      tabItem(tabName = "ardl",
              bs4Card(title = "Détails ARDL", width = 12, status = "primary", verbatimTextOutput("ardl_sum"))
      )
    )
  )
)

# ============================================================
# SERVER (Logique)
# ============================================================
server <- function(input, output, session) {
  
  # Navigation
  observeEvent(input$go_data, { updateTabItems(session, "sidebar_id", "donnees") })
  observeEvent(input$go_comp, { updateTabItems(session, "sidebar_id", "comparaison") })
  
  # Table de données (Aperçu)
  output$data_head <- renderTable({
    req(data_ts)
    data_ts %>% as_tibble() %>%
      mutate(periode = format(as.Date(periode, origin = "1970-01-01"), "%b %Y")) %>%
      head(10)
  })
  
  # --- LOGIQUE COMPARAISON ---
  output$metrics_table <- renderTable({
    req(metrics_df)
    metrics_df
  })
  
  output$forecast_plot <- renderPlot({
    req(forecast_df)
    ggplot(forecast_df, aes(x = date)) +
      geom_line(aes(y = inflation_reelle, color = "Réel"), linewidth = 1) +
      geom_line(aes(y = inflation_sarima, color = "SARIMA"), linewidth = 1) +
      geom_line(aes(y = inflation_XGB, color = "XGBoost"), linetype = "dashed") +
      scale_color_manual(values = c("Réel" = "black", "SARIMA" = "#6f42c1", "XGBoost" = "#fd7e14")) +
      labs(title = "Inflation réelle vs prévisions", y = "Inflation", color = "Série") +
      theme_minimal()
  })
  
  # --- LOGIQUE PRÉDICTION ---
  output$sarima_plot <- renderPlot({
    f_sarima <- forecast(sarima_model, h = input$h_val)
    autoplot(f_sarima) + theme_minimal() + labs(title = "Projection future")
  })
  
  output$ardl_sum <- renderPrint({ summary(model_ardl) })
}

shinyApp(ui, server)

