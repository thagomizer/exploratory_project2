# Question 3

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

baltimorePM25 <- pm25[pm25["fips"] == "24510",]
baltimorePM25$typefactor <- factor(baltimorePM25$type)

emissionsByYearByType <- ddply(baltimorePM25, c("year", "typefactor"), summarise, total = sum(Emissions))

png(filename="baltimore_emissions_by_type.png")
qplot(x = year,
      xlab = "Year",
      y = total,
      ylab = "Total Emissions",
      data = emissionsByYearByType,
      color = typefactor,
      geom = c("point", "smooth"))
dev.off()


