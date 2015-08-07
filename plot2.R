library(lubridate)

# Load data archive from the Internet if it does not exist
if (!file.exists('household_power_consumption.txt')) {
    if (!file.exists('exdata%2Fdata%2Fhousehold_power_consumption.zip')) {
        cat('Downloading data archive\n')
        download.file('http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', 'exdata%2Fdata%2Fhousehold_power_consumption.zip')
    }
    cat('Unpacking data archive\n')
    # Unpack the archive
    unzip('exdata%2Fdata%2Fhousehold_power_consumption.zip')
}

# Load data set
cat('Loading data file\n')
data <- read.csv('household_power_consumption.txt', na.strings = c('?'), header = T, sep=';')


cat('Processing data\n')

# Prepare data set, subset only data from the dates 2007-02-01 and 2007-02-02.
data$Datetime <- dmy_hms(paste(data$Date, data$Time))
data <- data[year(data$Datetime) == 2007 & month(data$Datetime) == 2 & day(data$Datetime) %in% c(1,2),]
rownames(data) <- 1:nrow(data)
colnames(data) <- tolower(colnames(data))

# Set locale so we have correct wday labels
Sys.setlocale(category = "LC_ALL", locale = "English_United States.1252")
# Make the plot
with(data, plot(datetime, global_active_power, type='n',
                xlab='',
                ylab='Global Active Power (kilowatts)'))
with(data, lines(datetime, global_active_power))

# Save the plot into a file
dev.copy(png, filename="plot2.png");
dev.off ();

cat('Done\n')