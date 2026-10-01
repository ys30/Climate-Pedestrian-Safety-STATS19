# 03 — Pedestrian injury-severity models

library(dplyr)
library(nnet)
library(pROC)

model_data <- pedestrian_data %>%
  select(
    casualty_severity, fatal_or_serious,
    weather_conditions, light_conditions, road_surface_conditions,
    pedestrian_movement, pedestrian_crossing_physical_facilities,
    speed_limit, urban_or_rural_area, vehicle_manoeuvre,
    age_of_casualty, sex_of_casualty, hour, day_of_week
  ) %>%
  na.omit()

# Binary: Fatal/Serious vs Slight
binary_full <- glm(
  fatal_or_serious ~ weather_conditions + light_conditions +
    road_surface_conditions + pedestrian_movement +
    pedestrian_crossing_physical_facilities + speed_limit +
    urban_or_rural_area + vehicle_manoeuvre + age_of_casualty +
    sex_of_casualty + hour + day_of_week,
  data = model_data,
  family = binomial(link = "logit")
)

# Three-level severity model
multinomial_full <- multinom(
  casualty_severity ~ weather_conditions + light_conditions +
    road_surface_conditions + pedestrian_movement +
    pedestrian_crossing_physical_facilities + speed_limit +
    urban_or_rural_area + vehicle_manoeuvre + age_of_casualty +
    sex_of_casualty + hour + day_of_week,
  data = model_data,
  model = TRUE
)

# Environmental interaction specification
multinomial_interaction <- multinom(
  casualty_severity ~ weather_conditions * road_surface_conditions +
    light_conditions + urban_or_rural_area +
    pedestrian_crossing_physical_facilities + speed_limit +
    vehicle_manoeuvre + age_of_casualty + hour + day_of_week,
  data = model_data,
  model = TRUE
)

# Binary ROC
binary_prob <- predict(binary_full, type = "response")
binary_roc <- roc(model_data$fatal_or_serious, binary_prob)
print(auc(binary_roc))

# For multinomial models, evaluate the target class explicitly
# (e.g., Fatal one-vs-rest) when constructing ROC curves.
multinom_prob <- predict(multinomial_full, type = "probs")
fatal_target <- as.integer(model_data$casualty_severity == "Fatal")
fatal_roc <- roc(fatal_target, multinom_prob[, "Fatal"])
print(auc(fatal_roc))
