# Path to entire datafile
con <- file("../data/household_power_consumption.txt")

#determine line offsets for the first and last instances of the dates of interest
firstLine <- grep("1/2/2007", readLines(con))[1]
lastLines <- grep("2/2/2007", readLines(con))
lastLine <- lastLines[length(lastLines)]
numLines <- lastLine - (firstLine-1)
remove(lastLines)

# populate column names and classes for the data table
columnNames <- names(read.table(file("../data/household_power_consumption.txt"), nrows=1, sep=";", header=TRUE))
columnClasses <- c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")

# import the subset of the data that matches specified dates
powCon <- read.table(file("../data/household_power_consumption.txt"), header = FALSE, sep = ";", col.names = columnNames, colClasses = columnClasses, nrows = numLines, skip = (firstLine-1), na.strings = "?")

# add a timestamp column that combines the date and time class
powCon <- within(powCon, { timestamp = strptime(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S", tz = "US/Pacific") })

startTime <- strptime("2007-02-01", format="%Y-%m-%d", tz="US/Pacific")
endTime <- strptime("2007-02-03", format="%Y-%m-%d", tz="US/Pacific")

# reduce the data set to only the dates of interest
powCon <- powCon[which((powCon$timestamp >= startTime) & (powCon$timestamp < endTime)),]

#create the histogram for Plot 1 and save a copy to a PNG
png(filename = "plot1.png", width = 480, height = 480, units = "px", bg = "white")
hist(powCon$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()