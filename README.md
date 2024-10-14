# Template repository for running temperature and inflow scenarios using GLM-AED at Beaverdam Reservoir

## Guide to files:
`/sims/` includes sub-directories for each GLM-AED scenario

`/field_data/` is field observations to compare to model predictions

`/plots/` is for plots that are kept locally, not on GitHub

`run_GLMAED.R` **Start here!** just to make sure you can run the baseline scenario and access output. Also, this script installs `glmtools`, which you'll need to do if you are running in the  `rocker-flare 4.4` container.

`run_scenarios.R` Revise this script to create and run your own scenarios.
