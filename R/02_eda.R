# 02 — Exploratory summaries

library(dplyr)
library(ggplot2)

# Assumes pedestrian_data was created by 01_prepare_data.R.

severity_summary <- pedestrian_data %>%
  count(casualty_severity, name = "count") %>%
  mutate(share = count / sum(count))

weather_summary <- pedestrian_data %>%
  count(weather_conditions, name = "count") %>%
  arrange(desc(count))

print(severity_summary)
print(weather_summary)

ggplot(pedestrian_data, aes(weather_conditions, fill = casualty_severity)) +
  geom_bar(position = "fill") +
  labs(
    title = "Pedestrian Injury Severity by Weather Conditions",
    x = NULL, y = "Proportion"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(pedestrian_data, aes(light_conditions, fill = casualty_severity)) +
  geom_bar(position = "fill") +
  labs(
    title = "Pedestrian Injury Severity by Light Conditions",
    x = NULL, y = "Proportion"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
