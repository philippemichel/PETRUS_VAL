# Test Script with Example Data
# This script demonstrates the analysis workflow with the included example data
# Author: Philippe MICHEL
# Date: 2025-11-13

cat("=== PETRUS_VAL Test Script ===\n")
cat("Testing inter-observer analysis with example data\n\n")

# Note: This script requires R packages to be installed
# Run: source("scripts/00_setup.R") first

# Load required packages
if (!require("tidyverse", quietly = TRUE)) {
  stop("Please install required packages by running: source('scripts/00_setup.R')")
}

library(tidyverse)
library(irr)
library(psych)

# Load example data
cat("Loading example data...\n")
data <- read.csv("data/example_data.csv")

cat("\nData structure:\n")
str(data)

cat("\nFirst few rows:\n")
print(head(data))

cat("\nSummary of observations:\n")
cat("Number of ultrasound readings:", length(unique(data$reading_id)), "\n")
cat("Number of observers:", length(unique(data$observer_id)), "\n")
cat("Total observations:", nrow(data), "\n")

# Analysis 1: Technical Quality (Categorical)
cat("\n\n=== TECHNICAL QUALITY ANALYSIS ===\n")

# Reshape to wide format
tech_wide <- data %>%
  select(reading_id, observer_id, technical_quality) %>%
  pivot_wider(names_from = observer_id, values_from = technical_quality)

tech_matrix <- as.matrix(tech_wide[, -1])

# Calculate Fleiss' Kappa
cat("\nCalculating Fleiss' Kappa for Technical Quality...\n")
tech_kappa <- kappam.fleiss(tech_matrix)
cat("Fleiss' Kappa:", round(tech_kappa$value, 3), "\n")
cat("Interpretation:", 
    if(tech_kappa$value < 0.20) {"Poor agreement"} 
    else if(tech_kappa$value < 0.40) {"Fair agreement"}
    else if(tech_kappa$value < 0.60) {"Moderate agreement"}
    else if(tech_kappa$value < 0.80) {"Good agreement"}
    else {"Excellent agreement"}, "\n")

# Frequency table
cat("\nFrequency of ratings by observer:\n")
print(table(data$observer_id, data$technical_quality))

# Analysis 2: Overall Quality (Continuous)
cat("\n\n=== OVERALL QUALITY SCORE ANALYSIS ===\n")

# Reshape to wide format
overall_wide <- data %>%
  select(reading_id, observer_id, overall_quality) %>%
  pivot_wider(names_from = observer_id, values_from = overall_quality)

overall_matrix <- as.matrix(overall_wide[, -1])

# Calculate ICC
cat("\nCalculating ICC for Overall Quality Score...\n")
overall_icc <- ICC(overall_matrix)

icc_single <- overall_icc$results["ICC(2,1)", "ICC"]
icc_avg <- overall_icc$results["ICC(2,k)", "ICC"]

cat("ICC(2,1) - Single rater absolute agreement:", round(icc_single, 3), "\n")
cat("Interpretation:",
    if(icc_single < 0.50) {"Poor reliability"}
    else if(icc_single < 0.75) {"Moderate reliability"}
    else if(icc_single < 0.90) {"Good reliability"}
    else {"Excellent reliability"}, "\n")

cat("\nICC(2,k) - Average rater absolute agreement:", round(icc_avg, 3), "\n")
cat("Interpretation:",
    if(icc_avg < 0.50) {"Poor reliability"}
    else if(icc_avg < 0.75) {"Moderate reliability"}
    else if(icc_avg < 0.90) {"Good reliability"}
    else {"Excellent reliability"}, "\n")

# Descriptive statistics by observer
cat("\nDescriptive statistics by observer:\n")
desc_stats <- data %>%
  group_by(observer_id) %>%
  summarise(
    n = n(),
    mean = mean(overall_quality, na.rm = TRUE),
    sd = sd(overall_quality, na.rm = TRUE),
    median = median(overall_quality, na.rm = TRUE),
    min = min(overall_quality, na.rm = TRUE),
    max = max(overall_quality, na.rm = TRUE)
  )
print(desc_stats)

# Analysis 3: Adequacy (Binary)
cat("\n\n=== ADEQUACY ANALYSIS ===\n")

# Calculate percentage agreement for adequacy
adequacy_wide <- data %>%
  select(reading_id, observer_id, adequacy) %>%
  pivot_wider(names_from = observer_id, values_from = adequacy)

adequacy_matrix <- as.matrix(adequacy_wide[, -1])

# Fleiss' Kappa for binary variable
cat("\nCalculating Fleiss' Kappa for Adequacy...\n")
adequacy_kappa <- kappam.fleiss(adequacy_matrix)
cat("Fleiss' Kappa:", round(adequacy_kappa$value, 3), "\n")
cat("Interpretation:",
    if(adequacy_kappa$value < 0.20) {"Poor agreement"}
    else if(adequacy_kappa$value < 0.40) {"Fair agreement"}
    else if(adequacy_kappa$value < 0.60) {"Moderate agreement"}
    else if(adequacy_kappa$value < 0.80) {"Good agreement"}
    else {"Excellent agreement"}, "\n")

cat("\nPercentage of 'Yes' ratings by observer:\n")
adequacy_pct <- data %>%
  group_by(observer_id) %>%
  summarise(pct_yes = sum(adequacy == "Yes") / n() * 100)
print(adequacy_pct)

cat("\n\n=== TEST COMPLETE ===\n")
cat("Example analysis completed successfully!\n")
cat("Review the output above to understand the inter-observer agreement results.\n\n")
cat("Next steps:\n")
cat("1. Prepare your own data using the template in data/data_template.csv\n")
cat("2. Run the full analysis with scripts/01_interobserver_analysis.R\n")
cat("3. Generate a report with scripts/02_analysis_report.Rmd\n")
