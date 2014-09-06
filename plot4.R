# The file should be located in the work directory
zipHandle<-unz("exdata_data_household_power_consumption.zip", "household_power_consumption.txt")
df<-read.table(zipHandle, header = TRUE, sep = ";")
unlink(zipHandle)

# The first column comes as a factor, first convert it
# to a date
df$Date<-as.Date(df$Date, format = "%d/%m/%Y")

# Convert the time column
# the time var has to include the date too
# first make a new vector with only time/date data.
dateAndTime = paste(df$Date, df$Time)
df$Time<-strptime(dateAndTime, format="%F %H:%M:%S")

# set the start and end day, should be the same format as the column
startDay<-as.Date("01/02/2007", format = "%d/%m/%Y")
endDay<-as.Date("02/02/2007", format = "%d/%m/%Y")

# cut out the rows for which df$Date is after
# the startdate and before the enddate
df<-df[df$Date >=startDay & df$Date <= endDay , ]

# this part converts values
# if you convert from factor to numeric directly things seem to go wrong.
df$Global_active_power<-as.numeric(as.character(df$Global_active_power))

df$SubMetering1<-as.numeric(as.character(df$Sub_metering_1))
df$SubMetering2<-as.numeric(as.character(df$Sub_metering_2))
df$SubMetering3<-as.numeric(as.character(df$Sub_metering_3))

df$Voltage<-as.numeric(as.character(df$Voltage))
df$Global_active_power<-as.numeric(as.character(df$Global_active_power))
df$Global_reactive_power<-as.numeric(as.character(df$Global_reactive_power))

# open the graphics device
png(file = "plot4.png")

# set the 4 plots on one page option
par(mfrow = c(2,2))

# This part contains 4 plots

# plot 1 left top
plot(df$Time, df$Global_active_power, type = 'l', ylab = "Global Active Power (Kilowatts)", xlab ='' )

# plot 2 right top
plot(df$Time, df$Voltage, type = 'l', ylab = "Voltage", xlab = "datetime")
#

# plot 3 left bottom
plot(df$Time, df$SubMetering1, col = "black", type = 'l', ylab = "Energy Sub Metering", xlab = '')
lines(df$Time, df$SubMetering2, col = "red", type = 'l')
lines(df$Time, df$SubMetering3, col = "blue", type = 'l')
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = 1 ,col = c("black", "red", "blue") )

# plot4 right bottom
plot(df$Time, df$Global_reactive_power, type = 'l',ylab = "Global_reactive_power" , xlab = "datetime")

# close device png file
dev.off()

