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
inflow <- read_csv("sim/inputs/BVR_inflow_2015_2022_allfractions_2poolsDOC_withch4_metInflow_0.65X_silica_0.2X_nitrate_0.4X_ammonium_1.9X_docr_1.7Xdoc.csv")

#####:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::####
# WILDFIRE DATA 

# DATAFRAME FOR 100% BURN INTENSITY 
fire100 <- inflow %>% 
    mutate(FLOW = FLOW * 1.4, #highest for most intense burn, linear
           NIT_nit = NIT_nit *3.5, # highest for most intense burn, linear
           PHS_frp = PHS_frp * 1.5, # highest for most intense burn, linear
           OGM_doc = OGM_doc * 0.315) # half the highest for 100% burn, nonlinear 

# DATAFRAME FOR 50% BURN INTENSITY 
fire50 <- inflow %>% 
  mutate(FLOW = FLOW * 1.2, # half the highest for 50% burn, linear
         NIT_nit = NIT_nit *2.25, # half the highest for 50% burn, linear
         PHS_frp = PHS_frp * 1.25, # half the highest for 50% burn, linear
         OGM_doc = OGM_doc * 0.63) # half the highest for 50% burn, nonlinear 

# DATAFRAME FOR 25% BURN INTENSITY 
fire25 <- inflow %>% 
  mutate(FLOW = FLOW * 1.1, # quarter the highest for 25% burn, linear
         NIT_nit = NIT_nit *0.875, # quarter the highest for 25% burn, linear
         PHS_frp = PHS_frp * 0.375, # quarter the highest for 25% burn, linear
        OGM_doc = OGM_doc * 1.26) # highest for 25% burn, nonlinear 

#####:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::####
# LAND-USE DATA

# DATAFRAME FOR 100% RESIDENTIAL 
res100 <- inflow %>% 
    mutate(NIT_nit = NIT_nit * 3.92,
           PHS_frp = PHS_frp * 83)

# DATAFRAME FOR 50% RESIDENTIAL 
res50 <- inflow %>% 
  mutate(NIT_nit = NIT_nit * 1.96,
         PHS_frp = PHS_frp * 41.5)

# DATAFRAME FOR 25% RESIDENTIAL 
res25 <- inflow %>% 
  mutate(NIT_nit = NIT_nit * 0.98,
         PHS_frp = PHS_frp * 20.75)

# DATAFRAME FOR 100% AGRICULTURE 
ag100 <- inflow %>% 
    mutate(NIT_nit = NIT_nit * 8.28,
           PHS_frp = PHS_frp * 130)

# DATAFRAME FOR 50% AGRICULTURE
ag50 <- inflow %>% 
  mutate(NIT_nit = NIT_nit * 4.14,
         PHS_frp = PHS_frp * 65)

# DATAFRAME FOR 25% AGRICULTURE
ag25 <- inflow %>% 
  mutate(NIT_nit = NIT_nit * 2.07,
         PHS_frp = PHS_frp * 32.5)

