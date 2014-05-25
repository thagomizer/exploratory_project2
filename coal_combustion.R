# Question 4

library(plyr)
library(ggplot2)

if (!file.exists("NEI_data.zip")) {
  download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip", method = "curl")
}

if (!file.exists("Source_Classification_Code.rds")) {
  unzip("NEI_data.zip")
}

scc <- readRDS(file = "Source_Classification_Code.rds");
pm25 <- readRDS(file = "summarySCC_PM25.rds");

coalSources <- scc[grepl("Fuel Comb.*Coal", scc$EI.Sector),]

coalPM25 <- pm25[pm25$SCC %in% coalSources$SCC,]

emissionsByYear <- ddply(coalPM25, "year", summarise, total = sum(Emissions))

png(filename="coal_emissions_by_year.png")
qplot(x = year,
      xlab = "Year",
      y = total,
      ylab = "Total Emissions",
      data = emissionsByYear,
      geom = c("point", "smooth"))
dev.off()
