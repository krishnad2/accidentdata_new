shinyUI(pageWithSidebar(
  headerPanel("shiny App - Sparkr Demo for Accident Data"),
  
  sidebarPanel(
   
  h3("Help to run the App"),
  helpText("First wait one minute for the csv file to load.  Select
            Menu options one by one and observe the Results. Cross Tabs 
            Menu has two options. Race vs Gender gives Race-wise Gender
            Distribution. Race vs Violation gives the trffic violations 
            percentages of each violation ppercentages for each race.
            The Cluster Analysis  Menu gives the hierarchical cluster analysis
            solution for a two clusters. Plot Menu gives two plots, one is the 
            distribution of Races gender-wise and other is the Dendrogram of
            hierarchical cluster analysis"),
  h3("About Cluster Analysis Results"),
  helpText("The Cluster Analysis model gives the results for a two cluster solution. 
            Each Cluster groups counties in which similar violations were committed")),
  mainPanel(
    navbarPage("Accident Data!",
    tabPanel("Data Description", h1("Data Description"),
        verbatimTextOutput("datades")), 
    tabPanel("Explore Data",h1("Sample Data"),
        verbatimTextOutput("datadisplay")),
    navbarMenu("Cross Tabs",
     tabPanel("Race vs Gender", h1("Cross Tabulation - Race vs. Gender"),
                                verbatimTextOutput("rg")),
     tabPanel("Race vs Violation", h1("Cross Tabulation - Race vs. Violation"),
                                verbatimTextOutput("racevl"))),
    tabPanel("Cluster Analysis", h1("Cluster Analysis Results"),
                 h4("The Cluster Analysis model gives the results for a two 
                  cluster solution.  Each Cluster groups counties in which 
                  similar violations were committed."),
        verbatimTextOutput("cluster")),
    tabPanel("Dendrogram",h1("Dendrogram from Hierarchical Clustering"),
             plotOutput("dendo")),
    navbarMenu("Plots",
             tabPanel("Race vs Gender", h1("Plot - Race vs Gender"),
                      plotOutput("raceplot")),
             tabPanel("Gender vs Violation", h1("Plot - Race vs. Violation"),
                      plotOutput("genderplot")))
 ))))
    