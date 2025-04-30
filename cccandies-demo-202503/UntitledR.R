# minimal demo of a working SpaDES model with harvesting (using ws3)
# minimal demo of a working SpaDES model with harvesting (using ws3)
repos <- c("https://predictiveecology.r-universe.dev", getOption("repos"))
source("https://raw.githubusercontent.com/PredictiveEcology/pemisc/refs/heads/development/R/getOrUpdatePkg.R")
# getOrUpdatePkg(c("Require", "SpaDES.project"), c("1.0.1.9003", "0.1.1.9039")) # only install/update if required
# Require::Install("PredictiveEcology/SpaDES.project@development (HEAD)")
pkgload::load_all("~/GitHub/Require");pkgload::load_all("~/GitHub/SpaDES.project");
Require::setLinuxBinaryRepo()
Sys.setenv(RETICULATE_PYTHON=".venv/bin/python")

################################################################################
# define local variables (spades_ws3 module parameters)
base.year <- 2020
# basenames <- c("tsa08", "tsa16", "tsa24", "tsa40", "tsa41") # data included!
basenames <- list(c("tsa41")) # only run one TSA as a test (faster and simpler)
horizon <- 3 # this would typically be one or two rotations (10 or 20 periods)
period_length <- 10 # do not modify this unless you know what you are doing
# times <- list(start = 0, end = horizon - 1) # do not modify
tifPath <- "tif" # do not modify (works with included dataset)
# outputs <-data.frame(objectName = "landscape") # do not modify
scheduler.mode <- "areacontrol" # self-tuning oldest-first priority queue heuristic algorithm (should "just work")
# scheduler.mode <- "optimize" # this should also "just work" (needs more testing)
target.masks <- list(c('? ? ? ?')) # do not modify
target.scalefactors <- NULL
shp.path <- "gis/shp"
################################################################################

out <- SpaDES.project::setupProject(
  useGit = TRUE,
  paths = list(projectPath = "cccandies-demo-202503",
               modulePath = 'modules',
               inputPath = 'input',
               outputPath = 'output',
               cachePath = 'cache'),
  # overwrite = TRUE, # useGit = "eliotmcintire",
  modules = c("PredictiveEcology/spades_ws3_dataInit@main",
              "PredictiveEcology/spades_ws3@dev",
              "bogus_fire")
  ,
  times = list(start = 0, end = horizon - 1), # do not modify
  outputs = data.frame(objectName = "landscape"), # do not modify
  params = list(spades_ws3_dataInit = list(basenames = basenames,
                                           tifPath = tifPath,
                                           base.year = base.year,
                                           .saveInitialTime = 0,
                                           .saveInterval = 1,
                                           .saveObjects = c("landscape"),
                                           .savePath = file.path(paths$outputPath, "landscape")),
                spades_ws3 = list(basenames = basenames,
                                  horizon = 3,
                                  period_length = period_length,
                                  tif.path = tifPath,
                                  shp.path = shp.path,
                                  base.year = base.year,
                                  scheduler.mode = scheduler.mode,
                                  target.masks = target.masks,
                                  target.scalefactors = target.scalefactors),
                bogus_fire = list(p.to.zero = 0.99))
  ,
  packages = c("gert", "SpaDES", "reticulate", "httr"),
  require = "SpaDES.core"
)

simOut <- do.call(SpaDES.core::simInitAndSpades, out)
################################################################################
if (FALSE) {
  # set up SpaDES paths
  setPaths(modulePath = 'modules',
           inputPath = 'input',
           outputPath = 'output',
           cachePath = 'cache')
  paths <- getPaths()
  ################################################################################

  ################################################################################
  # define SpaDES module import list
  modules <- list('spades_ws3_dataInit', 'bogus_fire', 'spades_ws3')
  ################################################################################


  ################################################################################
  # define SpaDES params input arg data structure
  sim <- SpaDES.core::simInit(paths=out$paths, modules=out$modules, times=times, params=params, outputs=outputs)
  ################################################################################

  ################################################################################
  # run SpaDES simulation
  simOut <- SpaDES.core::spades(sim, debug=TRUE)
  #
}

################################################################################
# plot something ?
freq(sim$landscape$age) # this is not a great example (do better)
################################################################################

################################################################################
# example showing how it is possible to poke around the ws3 model directly
# py$simulate_harvest(sim$fm, list(c("tsa41")), 2020)
################################################################################


################################################################################
# compile some aggregated data tables from raw geotiff spades_ws3 model output
#years <- 2020:2099
#burned.area.tsa08 <- sapply(years, function(x){return(cellStats(raster(paste0('input/tif/tsa08/projected_fire_', x, '.tif')), sum) * 6.25)})
#burned.area.tsa16 <- sapply(years, function(x){return(cellStats(raster(paste0('input/tif/tsa16/projected_fire_', x, '.tif')), sum) * 6.25)})
#burned.area.tsa24 <- sapply(years, function(x){return(cellStats(raster(paste0('input/tif/tsa24/projected_fire_', x, '.tif')), sum) * 6.25)})
#burned.area.tsa40 <- sapply(years, function(x){return(cellStats(raster(paste0('input/tif/tsa40/projected_fire_', x, '.tif')), sum) * 6.25)})
#burned.area.tsa41 <- sapply(years, function(x){return(cellStats(raster(paste0('input/tif/tsa41/projected_fire_', x, '.tif')), sum) * 6.25)})
#harvested.area.tsa08 <- sapply(years, function(x){return(cellStats(raster(paste0('input/tif/tsa08/projected_harvest_', x, '.tif')), sum) * 6.25)})
#harvested.area.tsa16 <- sapply(years, function(x){return(cellStats(raster(paste0('input/tif/tsa16/projected_harvest_', x, '.tif')), sum) * 6.25)})
#harvested.area.tsa24 <- sapply(years, function(x){return(cellStats(raster(paste0('input/tif/tsa24/projected_harvest_', x, '.tif')), sum) * 6.25)})
#harvested.area.tsa40 <- sapply(years, function(x){return(cellStats(raster(paste0('input/tif/tsa40/projected_harvest_', x, '.tif')), sum) * 6.25)})
#harvested.area.tsa41 <- sapply(years, function(x){return(cellStats(raster(paste0('input/tif/tsa41/projected_harvest_', x, '.tif')), sum) * 6.25)})
################################################################################
