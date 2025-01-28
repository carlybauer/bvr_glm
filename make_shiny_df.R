# Make dataframe to put into shiny app 
# 5 Nov 2024
# Carly Bauer

# need to decide what we want to include in this dataframe / can create multiple

# BVR = 69 acres = 0.279 km2 = 27.9 ha
# 435 million gallons full pond = 1645554126.04 L
# need to change units of contaminant to be kg_ha_yr like Nicole's
# mass/area = (concentration(mol/L) * molar mass (g/mol) * volume (L)) /Area (m2)
# units:
## NIT nitrate NO3-: mmol N/m3
  ## 1mmol = 0.001 mol -> divide by 1000
  ## m3 to L -> multiply by 1000
  ## multiply by molar mass 62.0049 g/mol
  ## multiply by volume 1645554126.04 L
  ## divide all of that by 279000 m2
  ## get g/m2/yr 
  ## divide by 1000 -> kg
  ## divide by 10000 -> ha
  ## kg/ha/yr
## PHS PO4: mmol P/m3
  ## molar mass = 94.97 g/mol
## DOC: mmol C/m3
  ## molar mass = 12.01 g/mol 
## Algae: mmol algae/m3



# load packages 
rm(list=ls(all=TRUE))
library(dplyr)
library(tidyr)
library(readxl)
library(lubridate)
library(stringr)
library(ggplot2)
library(readr)

# # make dataframe headers we want
# # manually input values from sum_...csv to make this table
# df <- data.frame(
#   intensity = c(100, 
#              100, 50, 25, 
#              100, 50, 25, 
#              100, 50, 25),
#   landuse_type = c("forested", 
#                    "burned", "burned", "burned", 
#                    "residential", "residential", "residential",
#                    "agricultural", "agricultural", "agricultural"),
#   nitrogen = c(2.792121,
#                113.1634,74.21422,33.8482,
#                117.056,63.44959,36.90479,
#                237.1207,123.1865,66.88617),
#   phosphorus = c(3.377915,
#                  1157.691,57.21962,26.38202,
#                  2919.742,1465.202,739.3818,
#                  4566.522,2284.824,1149.588),
#   carbon = c(0.02392763,
#              209728.3,0.4053181,0.1868783,
#              20.68214,10.37883,5.237448,
#              32.34719,16.18466,8.143166),
#   algae = c(0,0,0,0,0,0,0,0,0,0)
# )

# read in csvs for each scenario and 
baseline <- read_csv('./data/baseline.csv') 

# ts_baseline <- baseline %>% 
#   select(-1, DateTime, -contains("Depth"), -DateTime.1, -DateTime.2, -DateTime.3, -DateTime.4)

ts_baseline <- baseline %>% 
  select(-1, DateTime, -DateTime.1, -DateTime.2, -DateTime.3, -DateTime.4, -DateTime.5, -DateTime.6,
         -Depth.1, -Depth.2, -Depth.3, -Depth.4, -Depth.5, -Depth.6)
ts_baseline <- ts_baseline %>%
  filter(near(Depth, 0.6722585, tol = 0.5))

#calculate total contaminant amount for kg_ha_yr
# sum_baseline <- baseline %>%
#   select(-1, -contains("DateTime"), -contains("Depth")) %>%
#   summarise(across(everything(), sum, na.rm = TRUE)) %>% 
#   mutate(NIT_nit = ((NIT_nit*62.0049*1645554126.04)/279000)/1000/10000) %>% 
#   mutate(PHS_frp = ((PHS_frp*94.97*1645554126.04)/279000)/1000/10000) %>% 
#   mutate(OGM_doc = ((PHS_frp*12.01*1645554126.04)/279000)/1000/10000)
##::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::##

fire100 <- read_csv('./data/fire100.csv')

ts_fire100 <- fire100 %>% 
  select(-1, DateTime, -DateTime.1, -DateTime.2, -DateTime.3, -DateTime.4, -DateTime.5, -DateTime.6,
         -Depth.1, -Depth.2, -Depth.3, -Depth.4, -Depth.5, -Depth.6)
ts_fire100<- ts_fire100%>% 
  filter(near(Depth, 0.7139032, tol = 0.5))

# calculate total contaminant amount for kg_ha_yr
# sum_fire100 <- fire100 %>%
#   select(-1, -contains("DateTime"), -contains("Depth")) %>%
#   summarise(across(everything(), sum, na.rm = TRUE)) %>% 
#   mutate(NIT_nit = ((NIT_nit*62.0049*1645554126.04)/279000)/1000/10000) %>% 
#   mutate(PHS_frp = ((PHS_frp*94.97*1645554126.04)/279000)/1000/10000) %>% 
#   mutate(OGM_doc = ((PHS_frp*12.01*1645554126.04)/279000)/1000/10000)
##::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::##

fire50 <- read_csv('./data/fire50.csv')

ts_fire50 <- fire50 %>% 
  select(-1, DateTime, -DateTime.1, -DateTime.2, -DateTime.3, -DateTime.4, -DateTime.5, -DateTime.6,
         -Depth.1, -Depth.2, -Depth.3, -Depth.4, -Depth.5, -Depth.6)

ts_fire50 <- ts_fire50 %>%
  filter(near(Depth, 0.7137348, tol = 0.5))

#calculate total contaminant amount for kg_ha_yr
# sum_fire50 <- fire50 %>%
#   select(-1, -contains("DateTime"), -contains("Depth")) %>%
#   summarise(across(everything(), sum, na.rm = TRUE)) %>% 
#   mutate(NIT_nit = ((NIT_nit*62.0049*1645554126.04)/279000)/1000/10000) %>% 
#   mutate(PHS_frp = ((PHS_frp*94.97*1645554126.04)/279000)/1000/10000) %>% 
#   mutate(OGM_doc = ((PHS_frp*12.01*1645554126.04)/279000)/1000/10000)
##::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::##

fire25 <- read_csv('./data/fire25.csv')

ts_fire25 <- fire25 %>% 
  select(-1, DateTime, -DateTime.1, -DateTime.2, -DateTime.3, -DateTime.4, -DateTime.5, -DateTime.6,
         -Depth.1, -Depth.2, -Depth.3, -Depth.4, -Depth.5, -Depth.6)

ts_fire25 <- ts_fire25 %>% 
  filter(near(Depth, 0.7137348, tol = 0.5))


# calculate total contaminant amount for kg_ha_yr
# sum_fire25 <- fire25 %>%
#   select(-1, -contains("DateTime"), -contains("Depth")) %>%
#   summarise(across(everything(), sum, na.rm = TRUE)) %>% 
#   mutate(NIT_nit = ((NIT_nit*62.0049*1645554126.04)/279000)/1000/10000) %>% 
#   mutate(PHS_frp = ((PHS_frp*94.97*1645554126.04)/279000)/1000/10000) %>% 
#   mutate(OGM_doc = ((PHS_frp*12.01*1645554126.04)/279000)/1000/10000)
##::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::##


ggplot(ts_baseline)+
  geom_point(aes(DateTime, PHY_tchla))+
  ggtitle("Baseline")

ggplot(ts_fire100)+
  geom_point(aes(DateTime, PHY_tchla))+
  ggtitle("Fire100")

ggplot(ts_fire50)+
  geom_point(aes(DateTime, PHY_tchla))+
  ggtitle("Fire50")

ggplot(ts_fire25)+
  geom_point(aes(DateTime, PHY_tchla))+
  ggtitle("Fire25")




# BELOW IS INFO FOR AG AND RES land uses, may not be most up to date 
# last edited in Nov 2024 

ag100 <- read_csv('./data/ag100.csv')
sum_ag100 <- ag100 %>%
  select(-1, -contains("DateTime"), -contains("Depth")) %>%
  summarise(across(everything(), sum, na.rm = TRUE)) %>% 
  mutate(NIT_nit = ((NIT_nit*62.0049*1645554126.04)/279000)/1000/10000) %>% 
  mutate(PHS_frp = ((PHS_frp*94.97*1645554126.04)/279000)/1000/10000) %>% 
  mutate(OGM_doc = ((PHS_frp*12.01*1645554126.04)/279000)/1000/10000)

ag50 <- read_csv('./data/ag50.csv')
sum_ag50 <- ag50 %>%
  select(-1, -contains("DateTime"), -contains("Depth")) %>%
  summarise(across(everything(), sum, na.rm = TRUE)) %>% 
  mutate(NIT_nit = ((NIT_nit*62.0049*1645554126.04)/279000)/1000/10000) %>% 
  mutate(PHS_frp = ((PHS_frp*94.97*1645554126.04)/279000)/1000/10000) %>% 
  mutate(OGM_doc = ((PHS_frp*12.01*1645554126.04)/279000)/1000/10000)

ag25 <- read_csv('./data/ag25.csv')
sum_ag25 <- ag25 %>%
  select(-1, -contains("DateTime"), -contains("Depth")) %>%
  summarise(across(everything(), sum, na.rm = TRUE)) %>% 
  mutate(NIT_nit = ((NIT_nit*62.0049*1645554126.04)/279000)/1000/10000) %>% 
  mutate(PHS_frp = ((PHS_frp*94.97*1645554126.04)/279000)/1000/10000) %>% 
  mutate(OGM_doc = ((PHS_frp*12.01*1645554126.04)/279000)/1000/10000)

res100 <- read_csv('./data/res100.csv')
sum_res100 <- res100 %>%
  select(-1, -contains("DateTime"), -contains("Depth")) %>%
  summarise(across(everything(), sum, na.rm = TRUE)) %>% 
  mutate(NIT_nit = ((NIT_nit*62.0049*1645554126.04)/279000)/1000/10000) %>% 
  mutate(PHS_frp = ((PHS_frp*94.97*1645554126.04)/279000)/1000/10000) %>% 
  mutate(OGM_doc = ((PHS_frp*12.01*1645554126.04)/279000)/1000/10000)

res50 <- read_csv('./data/res50.csv')
sum_res50 <- res50 %>%
  select(-1, -contains("DateTime"), -contains("Depth")) %>%
  summarise(across(everything(), sum, na.rm = TRUE)) %>% 
  mutate(NIT_nit = ((NIT_nit*62.0049*1645554126.04)/279000)/1000/10000) %>% 
  mutate(PHS_frp = ((PHS_frp*94.97*1645554126.04)/279000)/1000/10000) %>% 
  mutate(OGM_doc = ((PHS_frp*12.01*1645554126.04)/279000)/1000/10000)

res25 <- read_csv('./data/res25.csv')
sum_res25 <- res25 %>%
  select(-1, -contains("DateTime"), -contains("Depth")) %>%
  summarise(across(everything(), sum, na.rm = TRUE)) %>% 
  mutate(NIT_nit = ((NIT_nit*62.0049*1645554126.04)/279000)/1000/10000) %>% 
  mutate(PHS_frp = ((PHS_frp*94.97*1645554126.04)/279000)/1000/10000) %>% 
  mutate(OGM_doc = ((PHS_frp*12.01*1645554126.04)/279000)/1000/10000)
