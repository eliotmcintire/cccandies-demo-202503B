plotFireWithHarvest <- function(sim, resInHA = prod(sim$rasterToMatch)/1e4) {

  fire <- simOut$burnSummary
  fireByYear <- fire[, .(area = sum(areaBurned)), .(year)]
  fireByYear[, source := "fire"]

  harvest <- copy(as.data.table(simOut$harvestStats))
  harvest[, area := ws3_harvestArea_pixels * resInHA]
  harvest[, source := "harvest"]
  plotData <- rbind(harvest, fireByYear, fill = TRUE)

  ggplot(plotData, aes(x = year, y = area, col = source)) +
    geom_line() +
    scale_color_manual(values = c("red", "blue")) +
    labs(y = "area (ha)")

}
