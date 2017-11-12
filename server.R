options(shiny.maxRequestSize=400*1024^2) 
library(data.table)
shinyServer(function(input, output) {
 
 filedata <- reactive({dat <- data.frame(x = numeric(0), y = numeric(0))
 
 withProgress(message = 'Reading Data ! ', value = 0, {
   # Number of times we'll go through the loop
   n <- 100
   
   for (i in 1:n) {
     # Each time through the loop, add another row of data. This is
     # a stand-in for a long-running computation.
     dat <- rbind(dat, data.frame(x = rnorm(1), y = rnorm(1)))
     
     # Increment the progress bar, and update the detail text.
     incProgress(1/n, detail = paste("Doing part", i, " out of ",n))
     
     # Pause for 2.0 seconds to simulate a long computation.
     Sys.sleep(0.1)
   }
 #  df<-read.csv("cleaneddata.csv",header=TRUE,sep=",")
 })
 #   df<-read.csv("cleaneddata.csv",header=TRUE,sep=",")
     load("cleaneddata.RData")
     df
  })
  
  #This previews the CSV data file
  output$filetable <- renderTable({
    df<-data.frame(filedata())
    head(df)
  })  
  output$datades <- renderPrint({
    fileName <- "datades1.txt"
    conn <- file(fileName,open="r")
    linn <-readLines(conn)
    for (i in 1:length(linn)){
      print(linn[i])
    }
    close(conn)
  })

output$datadisplay <- renderPrint({
    df<-data.frame(filedata())
    head(df)
})


  output$rg <- renderPrint({
     df<-filedata()
     df<-data.frame(filedata())
     tbl<-table(df$driver_race,df$driver_gender)
     ptbl<-prop.table(tbl,margin=1)
     options(digits=2)
     ptbl
  })
  
  output$racevl <- renderPrint({
    df<-filedata()
    df<-data.frame(filedata())
    df$nviolation<-substr(df$violation,1,3)
    names(df$nviolation)<-"nviolation"
    df$nviolation<-factor(df$nviolation)
    t<-levels(df$nviolation)
    levels(df$nviolation)<-c("NKN",t[2:13])
    tbl1<-table(df$driver_race,df$nviolation)
    ptbl1<-prop.table(tbl1,margin=1)
    options(digits=2)
    ptbl1
  })
 
  output$cluster <- renderPrint({
    df<-filedata()
    df<-data.frame(filedata())
    df$nviolation<-substr(df$violation,1,3)
    names(df$nviolation)<-"nviolation"
    df$nviolation<-factor(df$nviolation)
    tbl<-table(df$county_name,df$nviolation)
    tbldf<-as.data.frame.matrix(tbl) 
    nm<-rownames(tbldf)
    tbldf$county<-nm
    tbl1<-(sapply(tbldf[1:11], scale))
    tbl2<-(sapply(tbldf[1:11], function(x) (x - min(x))/diff(range(x))))
    rownames(tbl2)<-rownames(tbldf)
  
    #Finding Euclidean Distance Matrix
    county.dist = dist(tbl2)
    # Perform Hierarchical Cluster Analysis
     county.hclust = hclust(county.dist)
     groups.2 = cutree(county.hclust,2)
    # table(groups.2)
     res<-sapply(unique(groups.2),function(g)tbldf$county[groups.2 == g])
     print("              Cluster Analysis Results for two clusters. ")
     print("Each Cluster groups counties in which similar violations were committed")
     res
   })
  
    output$raceplot <- renderPlot({
    df<-filedata()
    counts<-table(df$driver_race,df$driver_gender)
    cl1<-c("cyan","violet","green","blue","red")
    rplt<-barplot(counts,col=cl1,
     xlab="Race", ylab="Count",
     main="Distribution of Races - Genderwise",beside=TRUE)
    legend("topleft", legend=c("Asian", "Hispanic","Black","Others","White"),
       col=c("cyan","violet","green","blue","red"), lty=1:2, cex=0.8)
    rplt
  })
    output$genderplot <- renderPlot({
      df<-filedata()
      df$nviolation<-substr(df$violation,1,3)
      names(df$nviolation)<-"nviolation"
      df$nviolation<-factor(df$nviolation)
      counts<-table(df$nviolation,df$driver_gender)
      cl1<-rainbow(12)
      rplt<-barplot(counts,col=cl1,
                    xlab="Violations - Genderwise", ylab="Count",
                    main="Distribution of Violations - Genderwise",beside=TRUE)
      legend("topleft", legend=c("Not Known", "DUI related","Equipment","Licence","Light",
             "Others","Paper","Registration","Safety","Seating","Speed","Truck"),
             col=cl1, lty=1:2, cex=0.8)
      rplt
      
    })
 output$dendo <- renderPlot({
    df<-filedata()
    df<-data.frame(filedata())
    df$nviolation<-substr(df$violation,1,3)
    names(df$nviolation)<-"nviolation"
    df$nviolation<-factor(df$nviolation)
    
    tbl<-table(df$county_name,df$nviolation)
    tbldf<-as.data.frame.matrix(tbl) 
    nm<-rownames(tbldf)
    tbldf$county<-nm
    tbl1<-(sapply(tbldf[1:11], scale))
    tbl2<-(sapply(tbldf[1:11], function(x) (x - min(x))/diff(range(x))))
    rownames(tbl2)<-rownames(tbldf)
  
    #Finding Euclidean Distance Matrix
    county.dist = dist(tbl2)
    # Perform Hierarchical Cluster Analysis
     county.hclust = hclust(county.dist)
    plt<-plot(county.hclust,labels=tbldf$county,main='Default from hclust')
   })
})