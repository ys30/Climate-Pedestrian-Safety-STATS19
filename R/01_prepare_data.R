# Climate, Environment & Pedestrian Safety
# 01 — Acquire and prepare UK STATS19 pedestrian casualty data

library(stats19)
library(dplyr)
library(lubridate)

year <- 2022

collisions <- get_stats19(year = year, type = "collision", format = TRUE)
casualties <- get_stats19(year = year, type = "casualty", format = TRUE)
vehicles   <- get_stats19(year = year, type = "vehicle", format = TRUE)

pedestrian_data <- casualties %>%
  left_join(collisions, by = "accident_index") %>%
  left_join(vehicles, by = "accident_index") %>%
  filter(casualty_type == "Pedestrian") %>%
  mutate(
    date = as.Date(date),
    day_of_week = weekdays(date),
    hour = hour(hm(time)),
    fatal_or_serious = if_else(
      casualty_severity %in% c("Fatal", "Serious"), 1L, 0L
    ),
    casualty_severity = factor(
      casualty_severity,
      levels = c("Slight", "Serious", "Fatal")
    )
  )

write.csv(pedestrian_data, "prepared_pedestrian_data.csv", row.names = FALSE)
