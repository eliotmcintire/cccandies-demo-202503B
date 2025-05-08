## Everything in this file and any files in the R directory are sourced during `simInit()`;
## all functions and objects are put into the `simList`.
## To use objects, use `sim$xxx` (they are globally available to all modules).
## Functions can be used inside any function that was sourced in this module;
## they are namespaced to the module, just like functions in R packages.
## If exact location is required, functions will be: `sim$.mods$<moduleName>$FunctionName`.
defineModule(sim, list(
  name = "bogus_fire",
  description = "random fire",
  keywords = "",
  authors = structure(list(list(given = c("Elaheh"), family = "Ghasemi", role = c("aut", "cre"), email = "0@01101.io", comment = NULL)), class = "person"),
  childModules = character(0),
  version = list(bogus_fire = "0.0.0.9000"),
  timeframe = as.POSIXlt(c(NA, NA)),
  timeunit = "year",
  citation = list("citation.bib"),
  documentation = list("NEWS.md", "README.md", "bogus_fire.Rmd"),
  reqdPkgs = list("SpaDES.core (>= 2.1.0)", "ggplot2", "R.utils", "reticulate"),
  parameters = bindrows(
    defineParameter("p.to.zero", "numeric", 0.01, NA, NA, "Proportion of non NA pixels to burn at each time step.")
  ),
  inputObjects = bind_rows(
    expectsInput(objectName = "landscape", objectClass = "RasterStack", desc = "stand age", sourceURL = NA)
  ),
  outputObjects = bind_rows(
    createsOutput(objectName = 'landscape', objectClass = 'RasterStack', desc = 'raster stack of landscape attributes')
  )
))

doEvent.bogus_fire = function(sim, eventTime, eventType) {
  switch(
    eventType,
    init = {
      ### check for more detailed object dependencies:
      ### (use `checkObject` or similar)

      # do stuff for this event
      sim <- Init(sim)
      sim <- scheduleEvent(sim, start(sim), "bogus_fire", "fire")
      # schedule future event(s)
      #sim <- scheduleEvent(sim, P(sim)$.plotInitialTime, "bogus_fire", "plot")
      #sim <- scheduleEvent(sim, P(sim)$.saveInitialTime, "bogus_fire", "save")
    },
    plot = {},
    save = {
      sim <- Save(sim)
      sim <- scheduleEvent(sim, time(sim) + P(sim)$.saveInterval, "bogus_fire", "save")
    },
    fire = {
      sim <- applyFire(sim)
      sim <- scheduleEvent(sim, time(sim) + 1, "bogus_fire", "fire")
    },
    warning(paste("Undefined event type: '", current(sim)[1, "eventType", with = FALSE],
                  "' in module '", current(sim)[1, "moduleName", with = FALSE], "'", sep = ""))
  )
  return(invisible(sim))
}

### event functions
Init <- function(sim) {
  # # ! ----- EDIT BELOW ----- ! #

  # ! ----- STOP EDITING ----- ! #

  return(invisible(sim))
}
### Save events
Save <- function(sim) {

  sim <- saveFiles(sim)
  return(invisible(sim))
}

### Plot events
plotFun <- function(sim) {

  return(invisible(sim))
}

###  applyFire
applyFire <- function(sim) {

  if (is.null(sim$landscape)) {
    stop("Landscape object is not available.")
  }

  # Ensure that the landscape has an 'age' layer
  if ("age" %in% names(sim$landscape)) {
    # Retrieve the pct_to_zero parameter
    p.to.zero <- P(sim)$p.to.zero
    print(p.to.zero)

    # Apply pct_to_zero (set a percentage of pixels in 'age' layer to 0)
    #if (!is.null(pct_to_zero) && pct_to_zero > 0 && pct_to_zero <= 1) {

      # Get the 'age' layer values
      age.layer.vals <- values(sim$landscape[["age"]])

      # Identify non-NA cells
      non.na.cells <- which(!is.na(age.layer.vals))

      # Calculate the number of pixels to set to 0
      n.to.zero <- round(p.to.zero * length(non.na.cells))
      print(n.to.zero)
      # Randomly select pixels to set to 0
      set.zero <- sample(non.na.cells, n.to.zero)

      # Set the selected pixels to 0 in the 'age' layer
      age.layer.vals[set.zero] <- 0

      # Update the 'age' layer
      sim$landscape[["age"]] <- setValues(sim$landscape[["age"]], age.layer.vals)

    #} else {
    #  message("No valid pct_to_zero value provided, skipping fire application.")
    #}

    # Save the modified landscape
    #message("Saving modified landscape after fire...")
    #writeRaster(landscape, file.path(sim$paths$outputPath, "modified_landscape_with_fire.tif"), overwrite = TRUE)

    # Update the sim object
    #sim$modified_landscape <- landscape
  } else {
    stop("The 'age' layer is not found in the landscape raster.")
  }
  return(invisible(sim))
}


.inputObjects <- function(sim) {
  # Any code written here will be run during the simInit for the purpose of creating
  # any objects required by this module and identified in the inputObjects element of defineModule.
  # This is useful if there is something required before simulation to produce the module
  # object dependencies, including such things as downloading default datasets, e.g.,
  # downloadData("LCC2005", modulePath(sim)).
  # Nothing should be created here that does not create a named object in inputObjects.
  # Any other initiation procedures should be put in "init" eventType of the doEvent function.
  # Note: the module developer can check if an object is 'suppliedElsewhere' to
  # selectively skip unnecessary steps because the user has provided those inputObjects in the
  # simInit call, or another module will supply or has supplied it. e.g.,
  # if (!suppliedElsewhere('defaultColor', sim)) {
  #   sim$map <- Cache(prepInputs, extractURL('map')) # download, extract, load file from url in sourceURL
  # }

  #cacheTags <- c(currentModule(sim), "function:.inputObjects") ## uncomment this if Cache is being used
  dPath <- asPath(getOption("reproducible.destinationPath", dataPath(sim)), 1)
  message(currentModule(sim), ": using dataPath '", dPath, "'.")

  # ! ----- EDIT BELOW ----- ! #

  # ! ----- STOP EDITING ----- ! #
  return(invisible(sim))
}

ggplotFn <- function(data, ...) {
  ggplot2::ggplot(data, ggplot2::aes(TheSample)) +
    ggplot2::geom_histogram(...)
}

