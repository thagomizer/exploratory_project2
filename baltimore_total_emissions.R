# Question 2

library(plyr)

if (!file.exists("NEI_data.zip")) {
  download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip", method = "curl")
}

if (!file.exists("Source_Classification_Code.rds")) {
  unzip("NEI_data.zip")
}

scc <- readRDS(file = "Source_Classification_Code.rds");
pm25 <- readRDS(file = "summarySCC_PM25.rds");

baltimorePM25 <- pm25[pm25["fips"] == "24510",]

emissionsByYear <- ddply(baltimorePM25, "year", summarise, total = sum(Emissions))

png(filename="baltimore_total_emissions.png")
plot(x    = emissionsByYear$year,
     y    = emissionsByYear$total / 1000,
     type = "l",
     ylab = "Total Emissions from All Sources (kilotons)",
     xlab = "Year"
     )
dev.off()


