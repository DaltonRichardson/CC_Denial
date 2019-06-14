#' ---
#' title: "organize_data.R"
#' author: "Dalton Richardson"
#' ---

# This script will read in raw data from the input directory, clean it up to produce 
# the analytical dataset, and then write the analytical data to the output directory. 

#source in any useful functions
source("useful_functions.R")
library(MASS)
library(haven)
library(texreg)
mydata <- read_sav("input/CCAM SPSS Data(2).sav")

#clean and organize cliamtebelief variable
mydata$climatebelief <- factor(ifelse(mydata$happening<0|mydata$cause_original<0, NA,
                                      ifelse(mydata$happening==1,"Don't Believe",
                                             ifelse(mydata$cause_original==2, "Natural Change",
                                                    ifelse(mydata$cause_original==1, "Anthropogenic Change", NA)))),
                               levels=c("Don't Believe","Natural Change","Anthropogenic Change"))

#clean harm_US variable
mydata$harmUS <- factor(ifelse(mydata$harm_US==-1|mydata$harm_US==0, NA,
                               ifelse(mydata$harm_US==1, "Not At All",
                                      ifelse(mydata$harm_US==2, "Only A Little",
                                             ifelse(mydata$harm_US==3, "A Moderate Amount",
                                                    ifelse(mydata$harm_US==4, "A Great Deal", NA))))),
                        levels=c("Not At All","Only A Little","A Moderate Amount","A Great Deal"))
#dropped 2328

#clean service_attendance variable
mydata$service_attendance <- factor(ifelse(mydata$service_attendance==-1, NA,
                                            ifelse(mydata$service_attendance==1, "Never",
                                                   ifelse(mydata$service_attendance==2, "Once a Year",
                                                          ifelse(mydata$registered_voter==3, "Few Times a Year",
                                                                 ifelse(mydata$service_attendance==4, "Monthly",
                                                                        ifelse(mydata$service_attendance==5, "Weekly",
                                                                               ifelse(mydata$service_attendance==6, "Multiple Times a Week", NA))))))),
                          levels=c("Never","Once a Year","Few Times a Year","Monthly","Weekly","Multiple Times a Week"))
#droped 3603 cases

mydata$ideology <- factor(ifelse(mydata$ideology==-1, NA,
                                 ifelse(mydata$ideology==1, "Very Liberal",
                                        ifelse(mydata$ideology==2, "Somewhat Liberal",
                                               ifelse(mydata$ideology==3, "Moderate",
                                                      ifelse(mydata$ideology==4, "Somewhat Conservative",
                                                             ifelse(mydata$ideology==5, "Very Conservative", NA)))))),
                          levels=c("Very Conservative","Somewhat Conservative","Moderate","Somewhat Liberal","Very Liberal"))

#clean educ_category variable
mydata$educ_category <- factor(ifelse(mydata$educ_category==1, "Less Than High School",
                                      ifelse(mydata$educ_category==2, "High School",
                                             ifelse(mydata$educ_category==3, "Some College",
                                                    ifelse(mydata$educ_category==4, "Bachelor's Degree or Higher", NA)))),
                          levels=c("Less Than High School","High School","Some College","Bachelor's Degree or Higher"))     


#subset the data
mydata <- subset(mydata,
                 select=c("climatebelief","happening", "cause_original", "harmUS", "ideology",
                          "age","gender","generation","educ_category", "service_attendance"))
save(mydata, file="output/analytical_data.RData")
