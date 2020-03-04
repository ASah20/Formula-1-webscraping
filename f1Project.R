#Bring In Libraries
library(rvest)
library(dplyr)
library(plyr)

theurl2<-paste0("https://en.wikipedia.org/wiki/List_of_Formula_One_World_Drivers%27_Champions") 

html2<- read_html(theurl2)  

get_table2<-html_nodes(html2,xpath = '//*[@id="mw-content-text"]/div/table[2]') 

table_n<-html_table(get_table2) 

f1data<-data.frame(table_n[[1]], stringsAsFactors = F)
f1data <- f1data[-nrow(f1data),]
f1data$Driver<-gsub("\\[.*","",f1data$Driver)
f1data[f1data == "Mercedes2"] <- "Mercedes"
f1data[f1data == "Maserati2"] <- "Maserati"
f1data[f1data == "19521"] <- "1952"
f1data[f1data == "19531"] <- "1953"
#Constructor Nationalities
theurl3<-paste0("https://gpracingstats.com/constructors/") 

html3<- read_html(theurl3)  

get_table3<-html_nodes(html3,xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "constructor-list-past", " " ))]') 

table_o<-html_table(get_table3) 

ConstructorNat<-data.frame(table_o[[1]], stringsAsFactors = F)
ConstructorNat[ConstructorNat == "Lotus (1958-94)"] <- "Lotus"
ConstructorNat[ConstructorNat == "Brawn GP"] <- "Brawn"
f1data <- merge(f1data,ConstructorNat,by="Constructor")
f1data <-subset(f1data, select = -c(Year.s..active))
names(f1data)[names(f1data) == "Licensed.in"] <- "ConstructorNat"
f1data <- f1data[, -c(12:15)]
f1data$ConstructorNat<-gsub("\\s", "", f1data$ConstructorNat)
f1data[f1data == "France/UnitedKingdom"] <- "France"
f1data[f1data == "UnitedKingdom/Austria"] <- "Austria"
f1data[f1data == "Italy/Switzerland"] <- "Italy"
f1data[f1data == "UnitedKingdom/Italy"] <- "UnitedKingdom"

#Driver Nationalities


theurl4<-paste0("https://gpracingstats.com/drivers/") 

html4<- read_html(theurl4)  

get_table4<-html_nodes(html4,xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "driver-list-past", " " ))]') 

table_p<-html_table(get_table4) 

DriverNat<-data.frame(table_p[[1]], stringsAsFactors = F)
DriverNat[DriverNat == "Kimi Raikkonen"] <- "Kimi Räikkönen"
DriverNat[DriverNat == "Mika Hakkinen"] <- "Mika Häkkinen"
f1data$Driver<-gsub("\\s", "", f1data$Driver)
DriverNat$Driver<-gsub("\\s", "", DriverNat$Driver)
f1drivers<-subset(f1data, select = Driver)
f1data <- merge(f1data,DriverNat,by="Driver")
f1driv<-f1data$Driver %in% f1data2$Driver
names(f1data)[names(f1data) == "Country"] <- "DriverNat"
f1data <- f1data[, -c(14:15)]
f1data <- f1data[, -c(6)]
names(f1data)[names(f1data) == "F..Laps"] <- "FastestLaps"

write.table(f1data,"f1data.csv")
