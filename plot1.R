# The file should be located in the work directory
zipHandle<-unz("exdata_data_household_power_consumption.zip", "household_power_consumption.txt")
df<-read.table(zipHandle, header = TRUE, sep = ";")
unlink(zipHandle)

# The first column comes as a factor, first convert it
# to a date
df$Date<-as.Date(df$Date, format = "%d/%m/%Y")

# set the start and end day, should be the same format as the column
startDay<-as.Date("01/02/2007", format = "%d/%m/%Y")
endDay<-as.Date("02/02/2007", format = "%d/%m/%Y")

# cut out the rows for which df$Date is after
# the startdate and before the enddate
df<-df[df$Date >=startDay & df$Date <= endDay , ]

# if you convert from factor to numeric directly things seem to go wrong.
df$Global_active_power<-as.numeric(as.character(df$Global_active_power))

# no extra settings are needed for the resolution, since it already
# produces 480x480 images.
png(file = "plot1.png")

# write the plot to file.
hist(df$Global_active_power, col="Red", xlab="Global Active Power (kilowatts)", main="Global Active Power")

# close the file
dev.off()

