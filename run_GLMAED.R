# run the model
GLM3r::run_glm(sim_folder = "./sims/baseline")

# set nml file
nc_file <- file.path('sims/baseline/output/output.nc') 

# install glmtools
library(devtools)
devtools::install_github("rqthomas/glmtools", force = TRUE)

# access and plot temperature
current_temp <- glmtools::get_var(nc_file, var_name = "temp")
glmtools::plot_temp(nc_file, reference = "surface")
