# Inter-observer Agreement Analysis
# Study: PETRUS_VAL - Validation of Ultrasound Reading Quality
# Author: Philippe MICHEL
# Date: 2025-11-13

# Load required packages ----
library(tidyverse)
library(irr)       # For inter-rater reliability measures
library(psych)     # For ICC calculations
library(ggplot2)   # For plotting

# Set options ----
options(stringsAsFactors = FALSE)

# Create output directory if it doesn't exist ----
if (!dir.exists("results")) {
  dir.create("results")
}

# 1. Load data ----
cat("Loading data...\n")

# Replace 'data.csv' with your actual data file name
# The data should have columns: reading_id, observer_id, and rating columns
data <- read.csv("data/data.csv")

# Display data structure
cat("\nData structure:\n")
str(data)

cat("\nFirst few rows:\n")
head(data)

# 2. Data preparation ----
cat("\n\nPreparing data for analysis...\n")

# Check for missing values
cat("\nMissing values:\n")
print(colSums(is.na(data)))

# 3. Inter-observer agreement for categorical variables ----
cat("\n\n=== CATEGORICAL VARIABLE ANALYSIS ===\n")

# Function to calculate agreement for a categorical variable
analyze_categorical <- function(data, variable_name) {
  cat(sprintf("\n--- Analysis for: %s ---\n", variable_name))
  
  # Reshape data to wide format (rows = readings, columns = observers)
  wide_data <- data %>%
    select(reading_id, observer_id, all_of(variable_name)) %>%
    pivot_wider(names_from = observer_id, 
                values_from = all_of(variable_name))
  
  # Remove reading_id column and convert to matrix
  rating_matrix <- as.matrix(wide_data[, -1])
  
  # Calculate number of observers
  n_observers <- ncol(rating_matrix)
  
  # Calculate percentage agreement
  if (n_observers == 2) {
    agree_pct <- sum(rating_matrix[,1] == rating_matrix[,2], na.rm = TRUE) / 
                 sum(!is.na(rating_matrix[,1]) & !is.na(rating_matrix[,2])) * 100
    cat(sprintf("Percentage agreement: %.1f%%\n", agree_pct))
  }
  
  # Calculate Kappa
  if (n_observers == 2) {
    # Cohen's Kappa for 2 observers
    kappa_result <- kappa2(rating_matrix[, 1:2])
    cat(sprintf("Cohen's Kappa: %.3f (95%% CI: not shown)\n", kappa_result$value))
    cat(sprintf("Interpretation: %s\n", interpret_kappa(kappa_result$value)))
  } else if (n_observers > 2) {
    # Fleiss' Kappa for multiple observers
    kappa_result <- kappam.fleiss(rating_matrix)
    cat(sprintf("Fleiss' Kappa: %.3f\n", kappa_result$value))
    cat(sprintf("Interpretation: %s\n", interpret_kappa(kappa_result$value)))
  }
  
  # Confusion matrix for 2 observers
  if (n_observers == 2) {
    cat("\nConfusion Matrix:\n")
    print(table(rating_matrix[,1], rating_matrix[,2], 
                dnn = c("Observer 1", "Observer 2")))
  }
  
  return(list(matrix = rating_matrix, kappa = kappa_result))
}

# Helper function to interpret Kappa/ICC values
interpret_kappa <- function(value) {
  if (value < 0.20) return("Poor agreement")
  if (value < 0.40) return("Fair agreement")
  if (value < 0.60) return("Moderate agreement")
  if (value < 0.80) return("Good agreement")
  return("Excellent agreement")
}

# Example: Analyze technical_quality (modify based on your actual columns)
# Uncomment and modify as needed:
# results_technical <- analyze_categorical(data, "technical_quality")
# results_diagnostic <- analyze_categorical(data, "diagnostic_quality")

# 4. Inter-observer agreement for continuous/ordinal variables ----
cat("\n\n=== CONTINUOUS/ORDINAL VARIABLE ANALYSIS ===\n")

# Function to calculate ICC for continuous variables
analyze_continuous <- function(data, variable_name) {
  cat(sprintf("\n--- ICC Analysis for: %s ---\n", variable_name))
  
  # Reshape data to wide format
  wide_data <- data %>%
    select(reading_id, observer_id, all_of(variable_name)) %>%
    pivot_wider(names_from = observer_id, 
                values_from = all_of(variable_name))
  
  # Remove reading_id and convert to matrix
  rating_matrix <- as.matrix(wide_data[, -1])
  
  # Calculate ICC
  # ICC(2,1) for single rater absolute agreement
  # ICC(2,k) for average rater absolute agreement
  icc_result <- ICC(rating_matrix)
  
  cat("\nICC Results:\n")
  print(icc_result$results[c("ICC", "F", "p", "lower bound", "upper bound")])
  
  # Focus on ICC(2,1) and ICC(2,k)
  icc_single <- icc_result$results["ICC(2,1)", "ICC"]
  icc_avg <- icc_result$results["ICC(2,k)", "ICC"]
  
  cat(sprintf("\nICC(2,1) - Single rater absolute agreement: %.3f\n", icc_single))
  cat(sprintf("Interpretation: %s\n", interpret_kappa(icc_single)))
  
  cat(sprintf("\nICC(2,k) - Average rater absolute agreement: %.3f\n", icc_avg))
  cat(sprintf("Interpretation: %s\n", interpret_kappa(icc_avg)))
  
  # Descriptive statistics by observer
  cat("\nDescriptive statistics by observer:\n")
  desc_stats <- data %>%
    group_by(observer_id) %>%
    summarise(
      n = sum(!is.na(.data[[variable_name]])),
      mean = mean(.data[[variable_name]], na.rm = TRUE),
      sd = sd(.data[[variable_name]], na.rm = TRUE),
      median = median(.data[[variable_name]], na.rm = TRUE),
      min = min(.data[[variable_name]], na.rm = TRUE),
      max = max(.data[[variable_name]], na.rm = TRUE)
    )
  print(desc_stats)
  
  return(list(matrix = rating_matrix, icc = icc_result, stats = desc_stats))
}

# Example: Analyze overall_quality score
# Uncomment and modify as needed:
# results_overall <- analyze_continuous(data, "overall_quality")

# 5. Visualization ----
cat("\n\n=== CREATING VISUALIZATIONS ===\n")

# Function to create agreement heatmap
create_agreement_heatmap <- function(data, variable_name, output_file) {
  
  # Reshape to wide format
  wide_data <- data %>%
    select(reading_id, observer_id, all_of(variable_name)) %>%
    pivot_wider(names_from = observer_id, 
                values_from = all_of(variable_name))
  
  # Calculate pairwise agreement matrix
  observers <- names(wide_data)[-1]
  n_obs <- length(observers)
  agreement_matrix <- matrix(NA, n_obs, n_obs)
  rownames(agreement_matrix) <- observers
  colnames(agreement_matrix) <- observers
  
  for (i in 1:n_obs) {
    for (j in 1:n_obs) {
      if (i == j) {
        agreement_matrix[i, j] <- 1.0
      } else {
        obs1 <- wide_data[[observers[i]]]
        obs2 <- wide_data[[observers[j]]]
        agreement <- sum(obs1 == obs2, na.rm = TRUE) / 
                    sum(!is.na(obs1) & !is.na(obs2))
        agreement_matrix[i, j] <- agreement
      }
    }
  }
  
  # Convert to long format for ggplot
  agreement_df <- as.data.frame(agreement_matrix) %>%
    rownames_to_column("Observer1") %>%
    pivot_longer(cols = -Observer1, 
                 names_to = "Observer2", 
                 values_to = "Agreement")
  
  # Create heatmap
  p <- ggplot(agreement_df, aes(x = Observer1, y = Observer2, fill = Agreement)) +
    geom_tile(color = "white") +
    geom_text(aes(label = sprintf("%.2f", Agreement)), color = "black") +
    scale_fill_gradient2(low = "red", mid = "yellow", high = "green",
                        midpoint = 0.5, limits = c(0, 1)) +
    theme_minimal() +
    labs(title = paste("Inter-observer Agreement:", variable_name),
         x = "Observer", y = "Observer",
         fill = "Agreement") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave(output_file, p, width = 8, height = 6)
  cat(sprintf("Heatmap saved to: %s\n", output_file))
  
  return(p)
}

# Function to create Bland-Altman plot
create_bland_altman <- function(data, variable_name, obs1, obs2, output_file) {
  
  # Prepare data for two observers
  plot_data <- data %>%
    filter(observer_id %in% c(obs1, obs2)) %>%
    select(reading_id, observer_id, all_of(variable_name)) %>%
    pivot_wider(names_from = observer_id, 
                values_from = all_of(variable_name)) %>%
    mutate(
      mean = (!!sym(obs1) + !!sym(obs2)) / 2,
      diff = !!sym(obs1) - !!sym(obs2)
    )
  
  # Calculate mean difference and limits of agreement
  mean_diff <- mean(plot_data$diff, na.rm = TRUE)
  sd_diff <- sd(plot_data$diff, na.rm = TRUE)
  upper_loa <- mean_diff + 1.96 * sd_diff
  lower_loa <- mean_diff - 1.96 * sd_diff
  
  # Create plot
  p <- ggplot(plot_data, aes(x = mean, y = diff)) +
    geom_point(alpha = 0.6) +
    geom_hline(yintercept = mean_diff, color = "blue", linetype = "dashed") +
    geom_hline(yintercept = upper_loa, color = "red", linetype = "dashed") +
    geom_hline(yintercept = lower_loa, color = "red", linetype = "dashed") +
    geom_hline(yintercept = 0, color = "gray", linetype = "dotted") +
    labs(title = sprintf("Bland-Altman Plot: %s vs %s", obs1, obs2),
         subtitle = sprintf("Variable: %s", variable_name),
         x = "Mean of two ratings",
         y = "Difference between ratings") +
    theme_minimal() +
    annotate("text", x = min(plot_data$mean, na.rm = TRUE), y = upper_loa,
             label = sprintf("Upper LoA: %.2f", upper_loa), hjust = 0, vjust = -0.5) +
    annotate("text", x = min(plot_data$mean, na.rm = TRUE), y = lower_loa,
             label = sprintf("Lower LoA: %.2f", lower_loa), hjust = 0, vjust = 1.5) +
    annotate("text", x = min(plot_data$mean, na.rm = TRUE), y = mean_diff,
             label = sprintf("Mean diff: %.2f", mean_diff), hjust = 0, vjust = -0.5)
  
  ggsave(output_file, p, width = 10, height = 6)
  cat(sprintf("Bland-Altman plot saved to: %s\n", output_file))
  
  return(p)
}

# Example visualizations (uncomment and modify as needed):
# create_agreement_heatmap(data, "technical_quality", "results/heatmap_technical.png")
# create_bland_altman(data, "overall_quality", "OBS1", "OBS2", "results/bland_altman.png")

# 6. Summary report ----
cat("\n\n=== GENERATING SUMMARY REPORT ===\n")

# Function to create summary report
generate_summary_report <- function() {
  cat("\nSummary report placeholder\n")
  cat("This function would generate a comprehensive summary of all analyses\n")
  cat("Consider using rmarkdown::render() to create an HTML or PDF report\n")
}

generate_summary_report()

cat("\n\n=== ANALYSIS COMPLETE ===\n")
cat("Review the console output and check the 'results/' directory for plots\n")
