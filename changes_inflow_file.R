# reads inflow file and changes it based on scenario then resaves as new csv
# CEB 
# 8 OCT 2024

rm(list=ls(all=TRUE))
library(dplyr)
library(tidyr)
library(readxl)
library(lubridate)
library(stringr)
library(ggplot2)
library(readr)

# read in original csv that will be used as forested/unburned landscape
inflow <- read_csv("sims/baseline/inputs/inflow_baseline.csv")

# uncomment below if wanting to compare the manipualted inflow file to the 
# baseline 2020
# inflow <- inflow %>% 
#   filter(lubridate::year(time) == 2020)

#####:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::####
# WILDFIRE DATA 

# DATAFRAME FOR 100% BURN INTENSITY 
fire100 <- inflow %>% 
    mutate(#FLOW = FLOW * 1.4, #highest for most intense burn, linear
           NIT_nit = NIT_nit *3.5, # highest for most intense burn, linear, Caldwell et al., 2020
           PHS_frp = PHS_frp * 1.5) # highest for most intense burn, linear, Caldwell et al., 2020
           #OGM_doc = OGM_doc * 0.315) # half the highest for 100% burn, nonlinear 

write_csv(fire100, file = "sims/fire100/inputs/inflowfire100.csv")

ggplot(fire100)+
  geom_point(aes(time, TEMP))
ggplot(inflow)+
  geom_point(aes(time, TEMP))

# DATAFRAME FOR 50% BURN INTENSITY 
fire50 <- inflow %>% 
  mutate(#FLOW = FLOW * 1.2, # half the highest for 50% burn, linear
         NIT_nit = NIT_nit *2.25, # half the highest for 50% burn, linear
         PHS_frp = PHS_frp * 1.25) # half the highest for 50% burn, linear
         #OGM_doc = OGM_doc * 0.63) # half the highest for 50% burn, nonlinear 
write_csv(fire50, file = "sims/fire50/inputs/inflowfire50.csv" )

# DATAFRAME FOR 25% BURN INTENSITY 
fire25 <- inflow %>% 
  mutate(#FLOW = FLOW * 1.1, # quarter the highest for 25% burn, linear
         NIT_nit = NIT_nit *0.875, # quarter the highest for 25% burn, linear
         PHS_frp = PHS_frp * 0.375) # quarter the highest for 25% burn, linear
        #OGM_doc = OGM_doc * 1.26) # highest for 25% burn, nonlinear 
write_csv(fire25, file = "sims/fire25/inputs/inflowfire25.csv")









#####:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::####
# LAND-USE DATA

# DATAFRAME FOR 100% RESIDENTIAL, Wilson and Weng 2010
res100 <- inflow %>% 
    mutate(NIT_nit = NIT_nit * 3.92, #nitrogen_nitrate 
           PHS_frp = PHS_frp * 83)
write_csv(res100, file = "sims/res100/inputs/inflowres100.csv")


# DATAFRAME FOR 50% RESIDENTIAL 
res50 <- inflow %>% 
  mutate(NIT_nit = NIT_nit * 1.96,
         PHS_frp = PHS_frp * 41.5)
write_csv(res50, file = "sims/res50/inputs/inflowres50.csv")


# DATAFRAME FOR 25% RESIDENTIAL 
res25 <- inflow %>% 
  mutate(NIT_nit = NIT_nit * 0.98,
         PHS_frp = PHS_frp * 20.75)
write_csv(res25, file = "sims/res25/inputs/inflowres25.csv")


# DATAFRAME FOR 100% AGRICULTURE, Wilson and Weng 2010
ag100 <- inflow %>% 
    mutate(NIT_nit = NIT_nit * 8.28,
           PHS_frp = PHS_frp * 130)
write_csv(ag100, file = "sims/ag100/inputs/inflowag100.csv")


# DATAFRAME FOR 50% AGRICULTURE
ag50 <- inflow %>% 
  mutate(NIT_nit = NIT_nit * 4.14,
         PHS_frp = PHS_frp * 65)
write_csv(ag50, file = "sims/ag50/inputs/inflowag50.csv")


# DATAFRAME FOR 25% AGRICULTURE
ag25 <- inflow %>% 
  mutate(NIT_nit = NIT_nit * 2.07,
         PHS_frp = PHS_frp * 32.5)
write_csv(ag25, file = "sims/ag25/inputs/inflowag25.csv")


