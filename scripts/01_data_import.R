# Data Import Script for PETRUS_VAL Study
# Inter-observer Validation of Ultrasound Reading Quality

# Load required packages
library(tidyverse)
library(readxl)
library(janitor)

# Source custom functions
source("R/functions.R")

# Set working directory (if needed)
# setwd("path/to/PETRUS_VAL")

# Create output directory if it doesn't exist
if (!dir.exists("data/processed")) {
  dir.create("data/processed", recursive = TRUE)
}

#' Import data from CSV file
#' 
#' This function imports raw data from CSV format
#' Expected columns:
#' - patient_id: Unique patient identifier
#' - observer_id: Observer identifier (1, 2, etc.)
#' - assessment_date: Date of assessment
#' - Additional measurement columns
#' 
import_csv_data <- function(file_path) {
  cat("Importing data from:", file_path, "\n")
  
  # Read CSV file
  data <- read_csv(file_path, show_col_types = FALSE)
  
  # Clean column names
  data <- clean_names(data)
  
  # Basic validation
  cat("Data dimensions:", nrow(data), "rows,", ncol(data), "columns\n")
  cat("Column names:", paste(names(data), collapse = ", "), "\n")
  
  return(data)
}

#' Import data from Excel file
#' 
#' This function imports raw data from Excel format
#' 
import_excel_data <- function(file_path, sheet = 1) {
  cat("Importing data from:", file_path, "- Sheet:", sheet, "\n")
  
  # Read Excel file
  data <- read_excel(file_path, sheet = sheet)
  
  # Clean column names
  data <- clean_names(data)
  
  # Basic validation
  cat("Data dimensions:", nrow(data), "rows,", ncol(data), "columns\n")
  cat("Column names:", paste(names(data), collapse = ", "), "\n")
  
  return(data)
}

#' Validate data structure
#' 
#' Checks that required columns are present
#' 
validate_data_structure <- function(data, required_cols) {
  missing_cols <- setdiff(required_cols, names(data))
  
  if (length(missing_cols) > 0) {
    stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
  }
  
  cat("Data structure validated successfully.\n")
  return(TRUE)
}

# Example usage (uncomment and modify as needed):
# 
# # Import data
# raw_data <- import_csv_data("data/raw/ultrasound_readings.csv")
# 
# # Or from Excel
# # raw_data <- import_excel_data("data/raw/ultrasound_readings.xlsx", sheet = 1)
# 
# # Validate required columns
# required_columns <- c("patient_id", "observer_id", "assessment_date")
# validate_data_structure(raw_data, required_columns)
# 
# # Save imported data
# saveRDS(raw_data, "data/processed/imported_data.rds")
# write_csv(raw_data, "data/processed/imported_data.csv")

cat("\n=== Data Import Script Loaded ===\n")
cat("Available functions:\n")
cat("  - import_csv_data(file_path)\n")
cat("  - import_excel_data(file_path, sheet)\n")
cat("  - validate_data_structure(data, required_cols)\n")
cat("\nUncomment example usage section to run import.\n")
