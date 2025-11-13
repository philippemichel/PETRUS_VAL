# Data Preprocessing Script for PETRUS_VAL Study
# Inter-observer Validation of Ultrasound Reading Quality

# Load required packages
library(tidyverse)
library(janitor)

# Source custom functions
source("R/functions.R")

#' Reshape data from long to wide format for inter-observer comparison
#' 
#' Converts data with one row per observer-patient to format with one row per patient
#' and separate columns for each observer's ratings
#' 
#' @param data Data frame in long format
#' @param id_col Name of patient/subject ID column
#' @param observer_col Name of observer ID column
#' @param value_cols Vector of measurement column names
#' @return Data frame in wide format
reshape_for_comparison <- function(data, id_col = "patient_id", 
                                   observer_col = "observer_id", 
                                   value_cols) {
  
  cat("Reshaping data from long to wide format...\n")
  
  # Select relevant columns
  data_subset <- data %>%
    select(all_of(c(id_col, observer_col, value_cols)))
  
  # Reshape each value column
  wide_data <- data_subset %>%
    pivot_wider(
      id_cols = all_of(id_col),
      names_from = all_of(observer_col),
      values_from = all_of(value_cols),
      names_sep = "_obs"
    )
  
  cat("Reshaped to", nrow(wide_data), "rows with observer comparisons\n")
  
  return(wide_data)
}

#' Clean and prepare data for analysis
#' 
#' Performs data cleaning steps:
#' - Remove duplicates
#' - Handle missing values
#' - Convert data types
#' - Create derived variables
#' 
#' @param data Raw data frame
#' @return Cleaned data frame
clean_data <- function(data) {
  
  cat("Cleaning data...\n")
  original_rows <- nrow(data)
  
  # Remove duplicate rows
  data <- data %>% distinct()
  
  removed_duplicates <- original_rows - nrow(data)
  if (removed_duplicates > 0) {
    cat("Removed", removed_duplicates, "duplicate rows\n")
  }
  
  # Convert date columns if present
  date_cols <- names(data)[grepl("date", names(data), ignore.case = TRUE)]
  if (length(date_cols) > 0) {
    for (col in date_cols) {
      data[[col]] <- as.Date(data[[col]])
    }
    cat("Converted date columns:", paste(date_cols, collapse = ", "), "\n")
  }
  
  # Report missing values
  missing_summary <- data %>%
    summarise(across(everything(), ~sum(is.na(.)))) %>%
    pivot_longer(everything(), names_to = "variable", values_to = "n_missing") %>%
    filter(n_missing > 0)
  
  if (nrow(missing_summary) > 0) {
    cat("\nMissing values detected:\n")
    print(missing_summary)
  } else {
    cat("No missing values detected\n")
  }
  
  cat("Data cleaning complete:", nrow(data), "rows retained\n")
  
  return(data)
}

#' Filter data to include only paired observations
#' 
#' Ensures that only patients with readings from both observers are included
#' 
#' @param data Data frame with observer comparisons
#' @param obs1_col Column name for observer 1 measurement
#' @param obs2_col Column name for observer 2 measurement
#' @return Filtered data frame
filter_paired_observations <- function(data, obs1_col, obs2_col) {
  
  cat("\nFiltering for paired observations...\n")
  original_rows <- nrow(data)
  
  # Keep only rows with both observations present
  data_filtered <- data %>%
    filter(!is.na(.data[[obs1_col]]) & !is.na(.data[[obs2_col]]))
  
  retained_rows <- nrow(data_filtered)
  removed_rows <- original_rows - retained_rows
  
  cat("Retained", retained_rows, "paired observations\n")
  if (removed_rows > 0) {
    cat("Removed", removed_rows, "incomplete pairs\n")
  }
  
  return(data_filtered)
}

#' Create summary of observer characteristics
#' 
#' Generates descriptive statistics for each observer
#' 
#' @param data Data frame with observer information
#' @param observer_col Name of observer column
#' @return Summary table
summarize_observers <- function(data, observer_col = "observer_id") {
  
  observer_summary <- data %>%
    group_by(.data[[observer_col]]) %>%
    summarise(
      n_assessments = n(),
      .groups = "drop"
    )
  
  return(observer_summary)
}

# Example usage (uncomment and modify as needed):
# 
# # Load imported data
# raw_data <- readRDS("data/processed/imported_data.rds")
# 
# # Clean data
# cleaned_data <- clean_data(raw_data)
# 
# # Summarize observers
# observer_stats <- summarize_observers(cleaned_data)
# print(observer_stats)
# 
# # Reshape for comparison (specify your measurement variables)
# measurement_vars <- c("quality_score", "measurement_value")
# wide_data <- reshape_for_comparison(
#   cleaned_data, 
#   id_col = "patient_id",
#   observer_col = "observer_id",
#   value_cols = measurement_vars
# )
# 
# # Filter for paired observations
# # Example for a specific variable
# paired_data <- filter_paired_observations(
#   wide_data,
#   obs1_col = "quality_score_obs1",
#   obs2_col = "quality_score_obs2"
# )
# 
# # Save preprocessed data
# saveRDS(wide_data, "data/processed/preprocessed_data.rds")
# saveRDS(paired_data, "data/processed/paired_data.rds")

cat("\n=== Data Preprocessing Script Loaded ===\n")
cat("Available functions:\n")
cat("  - clean_data(data)\n")
cat("  - reshape_for_comparison(data, id_col, observer_col, value_cols)\n")
cat("  - filter_paired_observations(data, obs1_col, obs2_col)\n")
cat("  - summarize_observers(data, observer_col)\n")
cat("\nUncomment example usage section to run preprocessing.\n")
