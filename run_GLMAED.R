# Script to run GLM-AED and extract output
# Author: Mary Lofton
# Date: 03OOct24

# Purpose: run GLMAED and extract variables from the output using a netcdf

# load packages
library(tidyverse)
library(lubridate)

# set your sim folder
sim_folder <- "./sim"

# run the model
GLM3r::run_glm(sim_folder = sim_folder)

# open the output file
nc_file <- file.path(paste0(sim_folder, "/output/output.nc"))
nc <- ncdf4::nc_open(nc_file)
names(nc$var) # these are all the output variables from GLM-AED
names(nc$dim) # these are all the different dimension names of the netcdf

# pull temperature (as an example)
PHY_green_IN <- ncdf4::ncvar_get(nc, var = "PHY_green_IN")
dim(PHY_green_IN) # get dimensions of temperature data
# [1] 500 4984
# 500 is the number of layers (depths) in the model
# 4984 is the number of time points

# wrangle temp
PHY_green_IN_df <- data.frame(t(PHY_green_IN))

# get list of output times
start <- as.POSIXct('2015-07-07 00:00:00')
interval <- 60*12
end <- as.POSIXct('2022-05-03 00:00:00')
times <- data.frame(seq(from=start, by=interval*60, to=end)[-1])

# join temp_df and times
PHY_green_IN_df2 <- bind_cols(times, PHY_green_IN_df)
colnames(PHY_green_IN_df2)[1] <- "datetime"
PHY_green_IN_df3 <- PHY_green_IN_df2 %>%
  pivot_longer(X1:X500, names_to = "layer", values_to = "PHY_green_IN")

# get heights
heights <- ncdf4::ncvar_get(nc, var = "H")
heights_df <- data.frame(t(heights))
heights_df2 <- bind_cols(times, heights_df)
colnames(heights_df2)[1] <- "datetime"
heights_df3 <- heights_df2 %>%
  pivot_longer(X1:X500, names_to = "layer", values_to = "height")

# join all together
green_out <- left_join(heights_df3, PHY_green_IN_df3, by = c("datetime","layer"))  %>%
  select(-layer)

# select a particular depth
focal_depth <- 1.6
max_lake_depth <- 9.3
focal_height <- max_lake_depth - focal_depth

green_depth_out <- green_out %>%
  group_by(datetime) %>%
  slice(which.min(abs(height - focal_height)))

# plot temperature at one depth
ggplot(data = green_depth_out, aes(x = datetime, y = PHY_green_IN))+
  geom_line()+
  ggtitle("Depth ~ 1.6 m") +
  theme_bw()

# combines parameters interested in to 1 dataframe
baseparameters <- left_join(DOC_depth_out, Nit_depth_out, by = c("datetime", "height")) %>% 
  left_join(Oxy_depth_out, by = c("datetime", "height")) %>% 
  left_join(PHS_depth_out, by = c("datetime", "height"))

# Convert datetime to character format
baseparameters <- baseparameters %>%
  mutate (year = year(datetime)) %>% 
  filter (year == "2017") %>% 
  mutate (datetime = format(datetime, "%Y-%m-%d %H:%M:%S")) %>% 
  select(datetime, OGM_doc, NIT_nit, PHS_frp, OXY_oxy)

# saves dataframe as csv, need to change name
write_csv(baseparameters, file = "baseparameters.csv")
