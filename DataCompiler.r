library("readxl")
library("xlsx")
stat.bis<- as.data.frame(read.csv("gs_stat_bis_monthly_20211101_20211130.csv", stringsAsFactors = FALSE))
AoOtpSum <- read_excel("AoOtpSum_202111.xls")
AoTimeSum <- read_excel("AoTimeSum_202111.xls")
#Create empty data frame of size 32 x 9 (32 variables x 9 airlines)
df <- data.frame(matrix(NA, nrow = 9, ncol = 24))

#Name the columns accordingly for easy reference
names(df) <- c("Key_Performance_Indicator","Total_Arriving_Flights","Flights_Arriving_on_Time","Flights_Arriving_plus_15_mins","Arrival_OTP_vs_STA","Arrival_OTP_vs_STA_plus_15","Aircraft_damage_incidents","Total_Departing_flights_","dnata_delayed_flights_(D+0)","dnata_delayed_flights_(D+15)_plus_15","Overall_dnata_OTP","Overall_dnata_OTP_plus_15","Minutes_recovered","Minutes_saved","Minutes_lost","Departing_Passengers_","Departing_bags_","MHB_Pieces","MHB/1000_Pax","MHB/1000_bag","First_bag_achieved_","Baggage_delivery_-_First_Bag","Last_bag_achieved_","Baggage_delivery_-_Last_Bag")

#Change the first column to the airline name
names(df)[1] <- "Airline_code"

#Fill in the Airline code names
df[,1] <- c("AF", "CI", "CX", "EK", "EY", "GA", "KL", "LD", "UL")

#Set row names too
row.names(df) <- df[,1]

#Let's pre-process the AoOtpSum data to make it looks nicer
colnames(AoOtpSum) <- AoOtpSum[4,]
AoOtpSum<-AoOtpSum[-c(1:4),]
row.names(AoOtpSum) <- NULL

#Find the index of wanted flight
#airline.index <- which(AoOtpSum$AIRLINE==airline_code)
#AoOtpSum[airline.index,]

#For loops
for (airline_code in df[,1]){
  airline.index <- which(AoOtpSum$AIRLINE==airline_code)
  df[airline_code,2] <- AoOtpSum[airline.index,2]
  df[airline_code,8] <- AoOtpSum[airline.index,2]
  df[airline_code,3] <- AoOtpSum[airline.index,3]
  df[airline_code,4] <- AoOtpSum[airline.index,5]
}
#Let's pre-process the AoTimeSum data to make it looks nicer
colnames(AoTimeSum) <- AoTimeSum[4,]
AoTimeSum<-AoTimeSum[-c(1:4),]
row.names(AoTimeSum) <- NULL

#Find the index of wanted flight
#airline.index <- which(AoTimeSum$AIRLINE==airline_code)
#AoTimeSum[airline.index,]

#For loops
for (airline_code in df[,1]){
  airline.index <- which(AoTimeSum$AIRLINE==airline_code)
  df[airline_code,13] <- AoTimeSum[airline.index,3]
  df[airline_code,14] <- AoTimeSum[airline.index,2]
  df[airline_code,15] <- AoTimeSum[airline.index,4]
}
#Let's pre-process the AoTimeSum data to make it looks nicer
#stat.bis[1,]
colnames(stat.bis) <- stat.bis[1,]
stat.bis<-stat.bis[-1,]
row.names(stat.bis) <- NULL

#We need to tweak the data format because there are some white spaces.. and convert factor back to character for processing
stat.bis <- as.data.frame(apply(stat.bis,2,function(x)gsub('\\s+', '',x)))
stat.bis <- data.frame(lapply(stat.bis, as.character), stringsAsFactors=FALSE)

#One of the 9 airlines, LD is missing. Let's add a dummy row with 0 entries
str(stat.bis)
which(stat.bis$AIRLINE=="AF")
stat.bis[1,8]

stat.bis[13,] <- 0
stat.bis[13,1] <- "LD"

#For loops

for (airline_code in df[,1]){
  airline.index <- which(stat.bis$AIRLINE==airline_code)
  df[airline_code,16] <- stat.bis[airline.index,8]
  df[airline_code,17] <- stat.bis[airline.index,11]
  df[airline_code,21] <- stat.bis[airline.index,3]
  df[airline_code,23] <- stat.bis[airline.index,4]
}
#Let's convert all NA to 0 for easy reading
df[is.na(df)] <- 0

write.xlsx(df, file="Compiled_data.xlsx")