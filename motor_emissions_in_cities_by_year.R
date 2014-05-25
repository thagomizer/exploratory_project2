# Question 6

library(plyr)
library(ggplot2)

if (!file.exists("NEI_data.zip")) {
  download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip", method = "curl")
}

if (!file.exists("Source_Classification_Code.rds")) {
  unzip("NEI_data.zip")
}

scc <- readRDS(file = "Source_Classification_Code.rds")
pm25 <- readRDS(file = "summarySCC_PM25.rds")

subsetPM25 <- pm25[pm25$fips == "24510" | pm25$fips == "06037",]

motorSources <- scc[grepl("*Vehicles", scc$EI.Sector),]
motorPM25 <- subsetPM25[subsetPM25$SCC %in% motorSources$SCC,]

emissionsByYear <- ddply(motorPM25, c("year", "fips"), summarise, total = sum(Emissions))

emissionsByYear$city <- ifelse(emissionsByYear$fips == "24510", "Baltimore", "Los Angeles")

png(filename="motor_emissions_in_cities_by_year.png")
qplot(x      = year,
      xlab   = "Year",
      y      = total,
      ylab   = "Total Emissions",
      data   = emissionsByYear,
      color  = city,
      geom   = c("point", "smooth"),
      method = "loess")
dev.off()
