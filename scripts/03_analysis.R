# Statistical Analysis Script for PETRUS_VAL Study
# Inter-observer Validation of Ultrasound Reading Quality

# Load required packages
library(tidyverse)
library(irr)        # Inter-rater reliability
library(psych)      # ICC calculations
library(ggplot2)    # Visualization

# Source custom functions
source("R/functions.R")

# Create figures directory if it doesn't exist
if (!dir.exists("figures")) {
  dir.create("figures", recursive = TRUE)
}

#' Perform complete inter-observer agreement analysis
#' 
#' Runs all agreement analyses for a given variable
#' 
#' @param data Data frame with observer comparisons
#' @param var_name Name of the variable being analyzed
#' @param obs1_col Column name for observer 1
#' @param obs2_col Column name for observer 2
#' @param var_type Type of variable ("categorical", "ordinal", or "continuous")
#' @return List with analysis results
analyze_interobserver_agreement <- function(data, var_name, obs1_col, obs2_col, 
                                           var_type = "continuous") {
  
  cat("\n==============================================\n")
  cat("Analyzing:", var_name, "\n")
  cat("Type:", var_type, "\n")
  cat("==============================================\n")
  
  # Extract observer data
  obs1 <- data[[obs1_col]]
  obs2 <- data[[obs2_col]]
  
  # Remove missing values
  valid_idx <- complete.cases(obs1, obs2)
  obs1 <- obs1[valid_idx]
  obs2 <- obs2[valid_idx]
  n_pairs <- length(obs1)
  
  cat("Number of paired observations:", n_pairs, "\n\n")
  
  results <- list(
    variable = var_name,
    type = var_type,
    n_pairs = n_pairs
  )
  
  # Calculate percentage agreement
  percent_agree <- sum(obs1 == obs2) / n_pairs * 100
  results$percent_agreement <- percent_agree
  cat("Percentage Agreement:", round(percent_agree, 2), "%\n")
  
  # Type-specific analyses
  if (var_type == "categorical") {
    
    # Cohen's Kappa
    cat("\nCalculating Cohen's Kappa...\n")
    kappa_result <- calculate_kappa(obs1, obs2)
    results$kappa <- kappa_result
    
    cat("Cohen's Kappa:", round(kappa_result$value, 3), "\n")
    cat("95% CI: [", round(kappa_result$value - 1.96 * kappa_result$statistic, 3), 
        ",", round(kappa_result$value + 1.96 * kappa_result$statistic, 3), "]\n")
    cat("Interpretation:", interpret_kappa(kappa_result$value), "\n")
    
    # Confusion matrix
    confusion_mat <- table(Observer1 = obs1, Observer2 = obs2)
    results$confusion_matrix <- confusion_mat
    cat("\nConfusion Matrix:\n")
    print(confusion_mat)
    
  } else if (var_type == "ordinal") {
    
    # Weighted Kappa
    cat("\nCalculating Weighted Kappa...\n")
    weighted_kappa_result <- calculate_weighted_kappa(obs1, obs2)
    results$weighted_kappa <- weighted_kappa_result
    
    cat("Weighted Kappa:", round(weighted_kappa_result$value, 3), "\n")
    cat("95% CI: [", round(weighted_kappa_result$value - 1.96 * weighted_kappa_result$statistic, 3), 
        ",", round(weighted_kappa_result$value + 1.96 * weighted_kappa_result$statistic, 3), "]\n")
    cat("Interpretation:", interpret_kappa(weighted_kappa_result$value), "\n")
    
  } else if (var_type == "continuous") {
    
    # Convert to numeric if not already
    obs1 <- as.numeric(obs1)
    obs2 <- as.numeric(obs2)
    
    # ICC
    cat("\nCalculating Intraclass Correlation Coefficient (ICC)...\n")
    icc_result <- calculate_icc(obs1, obs2)
    results$icc <- icc_result
    
    # Get ICC(2,1) - two-way random effects, single rater
    icc_value <- icc_result$results$ICC[2]
    icc_lower <- icc_result$results$`lower bound`[2]
    icc_upper <- icc_result$results$`upper bound`[2]
    
    cat("ICC(2,1):", round(icc_value, 3), "\n")
    cat("95% CI: [", round(icc_lower, 3), ",", round(icc_upper, 3), "]\n")
    cat("Interpretation:", interpret_icc(icc_value), "\n")
    
    # Correlation
    cor_result <- cor.test(obs1, obs2)
    results$correlation <- cor_result
    cat("\nPearson Correlation:", round(cor_result$estimate, 3), "\n")
    cat("95% CI: [", round(cor_result$conf.int[1], 3), ",", 
        round(cor_result$conf.int[2], 3), "]\n")
    cat("p-value:", format.pval(cor_result$p.value, digits = 3), "\n")
    
    # Mean difference and SD
    diff <- obs1 - obs2
    mean_diff <- mean(diff)
    sd_diff <- sd(diff)
    results$mean_difference <- mean_diff
    results$sd_difference <- sd_diff
    
    cat("\nMean Difference (Obs1 - Obs2):", round(mean_diff, 3), "\n")
    cat("SD of Differences:", round(sd_diff, 3), "\n")
    
    # Bland-Altman plot
    cat("\nGenerating Bland-Altman plot...\n")
    ba_plot <- create_bland_altman_plot(obs1, obs2, var_name)
    results$bland_altman_plot <- ba_plot
    
    # Save plot
    plot_filename <- paste0("figures/bland_altman_", 
                           gsub(" ", "_", tolower(var_name)), ".png")
    ggsave(plot_filename, ba_plot, width = 8, height = 6, dpi = 300)
    cat("Plot saved to:", plot_filename, "\n")
    
    # Scatter plot
    scatter_data <- data.frame(Observer1 = obs1, Observer2 = obs2)
    scatter_plot <- ggplot(scatter_data, aes(x = Observer1, y = Observer2)) +
      geom_point(alpha = 0.6, size = 2) +
      geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
      geom_smooth(method = "lm", se = TRUE, color = "blue") +
      labs(
        title = paste("Observer Comparison:", var_name),
        x = "Observer 1",
        y = "Observer 2"
      ) +
      theme_minimal() +
      coord_fixed()
    
    results$scatter_plot <- scatter_plot
    
    scatter_filename <- paste0("figures/scatter_", 
                              gsub(" ", "_", tolower(var_name)), ".png")
    ggsave(scatter_filename, scatter_plot, width = 8, height = 6, dpi = 300)
    cat("Scatter plot saved to:", scatter_filename, "\n")
  }
  
  cat("\n==============================================\n")
  
  return(results)
}

#' Compile results from multiple variables
#' 
#' Creates a summary table of agreement statistics across variables
#' 
#' @param results_list List of analysis results
#' @return Data frame with summary statistics
compile_results_summary <- function(results_list) {
  
  summary_rows <- lapply(results_list, function(res) {
    row <- data.frame(
      Variable = res$variable,
      Type = res$type,
      N_Pairs = res$n_pairs,
      Percent_Agreement = round(res$percent_agreement, 2)
    )
    
    if (!is.null(res$kappa)) {
      row$Kappa <- round(res$kappa$value, 3)
      row$Kappa_Interpretation <- interpret_kappa(res$kappa$value)
    } else if (!is.null(res$weighted_kappa)) {
      row$Weighted_Kappa <- round(res$weighted_kappa$value, 3)
      row$Kappa_Interpretation <- interpret_kappa(res$weighted_kappa$value)
    }
    
    if (!is.null(res$icc)) {
      icc_value <- res$icc$results$ICC[2]
      row$ICC <- round(icc_value, 3)
      row$ICC_Interpretation <- interpret_icc(icc_value)
    }
    
    if (!is.null(res$correlation)) {
      row$Correlation <- round(res$correlation$estimate, 3)
    }
    
    if (!is.null(res$mean_difference)) {
      row$Mean_Diff <- round(res$mean_difference, 3)
      row$SD_Diff <- round(res$sd_difference, 3)
    }
    
    return(row)
  })
  
  summary_table <- bind_rows(summary_rows)
  return(summary_table)
}

# Example usage (uncomment and modify as needed):
# 
# # Load preprocessed data
# paired_data <- readRDS("data/processed/paired_data.rds")
# 
# # Define variables to analyze
# variables_to_analyze <- list(
#   list(name = "Quality Score", obs1 = "quality_score_obs1", 
#        obs2 = "quality_score_obs2", type = "ordinal"),
#   list(name = "Measurement Value", obs1 = "measurement_value_obs1", 
#        obs2 = "measurement_value_obs2", type = "continuous")
# )
# 
# # Run analyses
# all_results <- list()
# for (var in variables_to_analyze) {
#   result <- analyze_interobserver_agreement(
#     data = paired_data,
#     var_name = var$name,
#     obs1_col = var$obs1,
#     obs2_col = var$obs2,
#     var_type = var$type
#   )
#   all_results[[var$name]] <- result
# }
# 
# # Compile summary
# summary_table <- compile_results_summary(all_results)
# print(summary_table)
# 
# # Save results
# saveRDS(all_results, "data/processed/analysis_results.rds")
# write_csv(summary_table, "data/processed/summary_results.csv")

cat("\n=== Statistical Analysis Script Loaded ===\n")
cat("Available functions:\n")
cat("  - analyze_interobserver_agreement(data, var_name, obs1_col, obs2_col, var_type)\n")
cat("  - compile_results_summary(results_list)\n")
cat("\nUncomment example usage section to run analysis.\n")
