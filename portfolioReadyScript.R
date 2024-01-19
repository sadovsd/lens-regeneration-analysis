# Load Data
data <- read.csv("lens_regeneration_data.csv", header=TRUE)

# Remove extraneous column
data$X <- NULL  

# Exclude header rows from the multiple excell data sheets
data <- data[data$Rep != "Rep",]

# Reset row indices
row.names(data) <- NULL 

# Create Age and Day variables
data$Age <- rep(c(rep("Larvae", 162), rep("Juvenile", 162), rep("Adult", 162)), 4)
data$Day <- rep(c(rep(1, 486), rep(4, 486), rep(10, 486), rep(15, 486)))

# Convert Age to a factor variable and set reference levels
data$Age <- relevel(factor(data$Age), ref="Larvae")

# Convert certain columns to numeric for modeling
data[c("DAPI", "EdU")] <- lapply(data[c("DAPI", "EdU")], as.numeric)

# Add totals for EdU and DAPI columns (they were not there originally for some reason)
edu_totals <- c()
dapi_totals <- c()
for (i in seq(3, length(data$EdU), by=3)) {
  edu_totals <- c(edu_totals, sum(data$EdU[(i-2):(i-1)]))
  dapi_totals <- c(dapi_totals, sum(data$DAPI[(i-2):(i-1)]))
}

# Filter data to keep only total cell counts (every third row)
data <- data[seq(1, nrow(data),3),]
data$EdU <- edu_totals
data$DAPI <- dapi_totals



