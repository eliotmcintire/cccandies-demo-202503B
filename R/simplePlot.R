plotFireWithHarvest <- function(sim, resInHA = NULL) {
  if (is.null(resInHA)) {
    resInHA = as.integer(prod(res(sim$rasterToMatch))/1e4)
  }
  fire <- sim$burnSummary
  fireByYear <- fire[, .(area = sum(areaBurned)), .(year)]
  fireByYear[, source := "fire"]

  harvest <- copy(as.data.table(sim$harvestStats))
  harvest[, area := ws3_harvestArea_pixels * resInHA]
  harvest[, source := "harvest"]
  plotData <- rbind(harvest, fireByYear, fill = TRUE)

  ggplot(plotData, aes(x = year, y = area, col = source)) +
    geom_line() +
    scale_color_manual(values = c("red", "blue")) +
    labs(y = "area disturbed (ha)",
         title = paste0(sim@params$spades_ws3$basename, " with horizon = ", sim@params$spades_ws3$horizon))

}
