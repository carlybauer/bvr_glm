# Create and run GLMAED scenarios
# Author: Mary Lofton
# Date: 14OCT24

# Purpose: create multiple scenarios to run GLMAED and then run them and plot 
# some output

# CEB added code to extract .nc files and save variables we want as csv for each
# scenario 

# assign names to scenarios - THIS WILL NEED TO BE EDITED!
scenario_folder_names <- c("baseline",
                           "fire100", "fire50", "fire25")

# create a folder for each scenarios and populate with sim files
#glm_files = list.files("./sims/baseline", full.names = TRUE)[1:3]
# 
# for (j in 1:length(scenario_folder_names)){
#   subdirName <- paste0("./sims/",scenario_folder_names[j])
#   folder<-dir.create(subdirName)
#   file.copy(from = glm_files, to = subdirName, recursive = TRUE)
#   outputdirName <- paste0(subdirName,"/output")
#   output_folder<-dir.create(outputdirName)
# }

# apply changes to scenario files
# in this case, each scenario has some number of degrees C added to met Temp_C

# # set temperature increments - THIS WILL NEED TO BE EDITED!!
# temp_increments <- c(1,2,3,5)
# 
 for (j in 1:length(scenario_folder_names)){
#   
  # get met data filepath and read in met data
  # inflow_filepath <- paste0("./sims/",scenario_folder_names[j],"/inputs/met.csv")
  #met <- read.csv(met_filepath)
  
  # HERE THE SCENARIO IS APPLIED - THIS WILL NEED TO BE EDITED!
  #met$AirTemp <- met$AirTemp + temp_increments[j]
  #met$time <-as.POSIXct(strptime(met$time, "%Y-%m-%d %H:%M:%S", tz="EST")) 
  
  # write to file
  #new_inflow_filepath <- paste0("./sims/",scenario_folder_names[j],"/inputs/inflow_",scenario_folder_names[j],".csv")
  #write.csv(met, new_inflow_filepath, row.names = FALSE, quote = FALSE)
  
  # set nml to use scenario met data
  scenario_nml_file <- file.path(paste0("./sims/",scenario_folder_names[j],"/glm3.nml"))
  scenario_nml <- glmtools::read_nml(nml_file = scenario_nml_file)
  scenario_nml <- glmtools::set_nml(scenario_nml, arg_name = "inflow_fl", arg_val = paste0("inputs/inflow_",scenario_folder_names[j],".csv"))
  glmtools::write_nml(scenario_nml, file = scenario_nml_file)
}


# run and plot each scenario

for (j in 1:length(scenario_folder_names)){
  
  # run the model
  sim_folder = paste0("./sims/",scenario_folder_names[j])
  GLM3r::run_glm(sim_folder)
  
  # set nml file
  nc_file <- file.path(paste0("sims/",scenario_folder_names[j],"/output/output.nc")) 
  
  # # access and plot temperature
  # current_temp <- glmtools::get_var(nc_file, var_name = "OGM_doc")
  # p <- glmtools::plot_var(nc_file, var_name = "OGM_doc", reference = "surface", 
  #                         plot.title = scenario_folder_names[j])
  # plot_filename <- paste0("./plots/OGM_doc_",scenario_folder_names[j],".png")
  # ggplot2::ggsave(p, filename = plot_filename, device = "png",
  #                 height = 6, width = 8, units = "in")
  
}


#just plot
for (j in 1:length(scenario_folder_names)){
  
  nc_file <- file.path(paste0("sims/",scenario_folder_names[j],"/output/output.nc")) 
  
  # access and plot temperature
  current_temp <- glmtools::get_var(nc_file, var_name = "OGM_doc")
  p <- glmtools::plot_var(nc_file, var_name = "OGM_doc", reference = "surface", 
                          plot.title = scenario_folder_names[j])
  plot_filename <- paste0("./plots/OGM_doc_",scenario_folder_names[j],".png")
  ggplot2::ggsave(p, filename = plot_filename, device = "png",
                  height = 6, width = 8, units = "in")
  
}


# 
# # save dateframe for each scenario with variables we're interested in
# for (j in 1:length(scenario_folder_names)){
#   
#   nc_file <- file.path(paste0("sims/",scenario_folder_names[j],"/output/output.nc")) 
#   
#   #get variables we want
#   cyano <- glmtools::get_var(nc_file, var_name = "PHY_cyano")
#   green <- glmtools::get_var(nc_file, var_name = "PHY_green")
#   diatom <- glmtools::get_var(nc_file, var_name = "PHY_diatom")
#   NIT_nit <- glmtools::get_var(nc_file, var_name = "NIT_nit")
#   PHS_frp <- glmtools::get_var(nc_file, var_name = "PHS_frp")
#   OGM_doc <- glmtools::get_var(nc_file, var_name = "OGM_doc")
#   
#   # make dataframe and save .csv
#   df <- data.frame( NIT_nit, PHS_frp, OGM_doc, cyano, green, diatom)
#   data_filename <- paste0("./data/",scenario_folder_names[j],".csv")
#   write.csv(df, file = data_filename)
# 
# }

library(tidyverse)
# save dateframe for each scenario with variables we're interested in
for (j in 1:length(scenario_folder_names)){
  
  nc_file <- file.path(paste0("sims/",scenario_folder_names[j],"/output/output.nc")) 
  
  #get variables we want
  TOT_extc <- glmtools::get_var(nc_file, var_name = "TOT_extc", reference="surface") |> 
    pivot_longer(cols=starts_with("TOT_extc_"), names_to="Depth", names_prefix="TOT_extc_", values_to ="TOT_extc") |> 
    mutate(DateTime = as.POSIXct(strptime(DateTime, "%Y-%m-%d", tz="EST"))) 
  
  temp <- glmtools::get_var(nc_file, var_name = "temp", reference="surface") |> 
    pivot_longer(cols=starts_with("temp_"), names_to="Depth", names_prefix="temp_", values_to = "temp") |> 
    mutate(DateTime = as.POSIXct(strptime(DateTime, "%Y-%m-%d", tz="EST"))) 
  
  cyano <- glmtools::get_var(nc_file, var_name = "PHY_cyano", reference="surface") |> 
    pivot_longer(cols=starts_with("PHY_cyano_"), names_to="Depth", names_prefix="PHY_cyano_", values_to = "PHY_cyano") |> 
    mutate(DateTime = as.POSIXct(strptime(DateTime, "%Y-%m-%d", tz="EST"))) 
  
  chla <- glmtools::get_var(nc_file, var_name = "PHY_tchla", reference="surface") |> 
    pivot_longer(cols=starts_with("PHY_tchla_"), names_to="Depth", names_prefix="PHY_tchla_", values_to = "PHY_tchla") |> 
    mutate(DateTime = as.POSIXct(strptime(DateTime, "%Y-%m-%d", tz="EST")))   
  
  NIT_nit <- glmtools::get_var(nc_file, var_name = "NIT_nit", reference="surface") |> 
    pivot_longer(cols=starts_with("NIT_nit_"), names_to="Depth", names_prefix="NIT_nit_", values_to = "NIT_nit") |> 
    mutate(DateTime = as.POSIXct(strptime(DateTime, "%Y-%m-%d", tz="EST")))  
  
  PHS_frp <- glmtools::get_var(nc_file, var_name = "PHS_frp", reference="surface") |> 
    pivot_longer(cols=starts_with("PHS_frp_"), names_to="Depth", names_prefix="PHS_frp_", values_to = "PHS_frp") |> 
    mutate(DateTime = as.POSIXct(strptime(DateTime, "%Y-%m-%d", tz="EST"))) 
  
  OGM_doc <- glmtools::get_var(nc_file, var_name = "OGM_doc", reference="surface") |> 
    pivot_longer(cols=starts_with("OGM_doc_"), names_to="Depth", names_prefix="OGM_doc_", values_to = "OGM_doc") |> 
    mutate(DateTime = as.POSIXct(strptime(DateTime, "%Y-%m-%d", tz="EST"))) 
  
  # make dataframe and save .csv
  df <- data.frame(temp, TOT_extc, NIT_nit, PHS_frp, OGM_doc, cyano, chla)
  data_filename <- paste0("./data/",scenario_folder_names[j],".csv")
  write.csv(df, file = data_filename)
  
}

# lists variables available to save from output   
variable<-glmtools::sim_vars(file = "./sims/baseline/output/output.nc")
  