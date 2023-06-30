library(tidyverse)
library(readxl)

# catch
catch_raw <- read_xlsx(here::here("data-raw", "LFR_Catch_Raw.xlsx")) |>
  select(-actualCount) |> # all are "yes"
  mutate(lifeStage = if_else(lifeStage == "Button-up fry", "Fry", lifeStage)) |>
  glimpse()

write_csv(catch_raw, here::here("data", "catch.csv"))

# trap
trap_raw <- read_xlsx(here::here("data-raw", "LFR_Trap_Raw.xlsx")) |>
  mutate(waterTempUnit = if_else(waterTempUnit == "°C", "Celsius", "Fahrenheit")) |>
  glimpse()
write_csv(trap_raw, here::here("data", "trap.csv"))

# recaptures
recaptures_raw <- read_xlsx(here::here("data-raw", "LFR_Recaptures_Raw.xlsx")) |>
  mutate(forkLength = as.numeric(forkLength),
         totalLength = as.numeric(totalLength),
         markCode = as.character(markCode)) |>
  select(-c(lifeStage, mort, forkLength, totalLength, actualCountID,
            markCode)) |>
  glimpse()
write_csv(recaptures_raw, here::here("data", "recaptures.csv"))

# releases
release_raw <- read_xlsx(here::here("data-raw", "LFR_Release_Raw.xlsx")) |>
  glimpse()
write_csv(release_raw, here::here("data", "release.csv"))

# releasefish - empty
release_fish_raw <- read_xlsx(here::here("data-raw", "LFR_ReleaseFish_Raw.xlsx")) |>
  glimpse()


# read in clean data to double check --------------------------------------
catch <- read_csv(here::here("data", "catch.csv")) |> glimpse()
trap <- read_csv(here::here("data", "trap.csv")) |> glimpse()
recaptures <- read_csv(here::here("data", "recaptures.csv")) |> glimpse()
release <- read_csv(here::here("data", "release.csv")) |> glimpse()

# function for checking metadata ------------------------------------------
get_class <- function(data, name) {
  data |> select(all_of(name)) |>
    pull() |> class()
}
report_metadata <- function(data) {
  names <- names(data)
  for(i in names) {
    print(i)
    if(get_class(data, i)[1] == "character") {
      values <- data |> select(all_of(i)) |> pull()
      dput(unique(values))
    }
    else if(get_class(data, i)[1] == "numeric") {
      print(data |> select(all_of(i)) |> pull() |> range(na.rm = T))
    }
    else if(get_class(data, i)[1] == "POSIXct") {
      print(data |> select(all_of(i)) |> pull() |> range(na.rm = T))
    }
    else if (get_class(data, i)[1] == "logical") {
      print(data |> select(all_of(i)) |> pull() |> unique())
    }
    else{
      print("unknown data type")
    }
  }
}

