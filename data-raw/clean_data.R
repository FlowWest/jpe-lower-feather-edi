library(tidyverse)
library(readxl)
# Note that we will no longer use this clean data script.
# Ashley met with Claire to update queries to remove the appropriate tables
# All additional processing will happen when we pull in data to database.
# catch
catch_raw <- read_xlsx(here::here("data-raw", "LFR_Catch_Raw.xlsx")) |>
  select(-actualCount) |> # all are "yes"
  mutate(lifeStage = if_else(lifeStage == "Button-up fry", "Fry", lifeStage)) |>
  glimpse()

write_csv(catch_raw, here::here("data", "lower_feather_catch.csv"))

# trap
trap_raw <- read_xlsx(here::here("data-raw", "LFR_Trap_Raw.xlsx")) |>
  mutate(waterTempUnit = if_else(waterTempUnit == "°C", "Celsius", "Fahrenheit")) |>
  glimpse()
write_csv(trap_raw, here::here("data", "lower_feather_trap.csv"))

# recaptures
recaptures_raw <- read_xlsx(here::here("data-raw", "LFR_Recaptures_Raw.xlsx")) |>
  mutate(forkLength = as.numeric(forkLength),
         totalLength = as.numeric(totalLength),
         markCode = as.character(markCode)) |>
  select(-c(lifeStage, mort, forkLength, totalLength, actualCountID,
            markCode)) |>
  glimpse()
write_csv(recaptures_raw, here::here("data", "lower_feather_recapture.csv"))

# releases
release_raw <- read_xlsx(here::here("data-raw", "LFR_Release_Raw.xlsx")) |>
  glimpse()
write_csv(release_raw, here::here("data", "lower_feather_release.csv"))

# releasefish - empty
release_fish_raw <- read_xlsx(here::here("data-raw", "LFR_ReleaseFish_Raw.xlsx")) |>
  glimpse()


# read in clean data to double check --------------------------------------
catch <- read_csv(here::here("data", "lower_feather_catch.csv")) |> glimpse()
trap <- read_csv(here::here("data", "lower_feather_trap.csv")) |> glimpse()
recapture <- read_csv(here::here("data", "lower_feather_recapture.csv")) |> glimpse()
release <- read_csv(here::here("data", "lower_feather_release.csv")) |> glimpse()
