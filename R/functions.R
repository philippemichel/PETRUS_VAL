# Custom Functions for PETRUS_VAL Study
# Inter-observer Validation of Ultrasound Reading Quality

#' Calculate Inter-observer Agreement Statistics
#'
#' @param data A data frame with observer ratings
#' @param var_name Name of the variable to analyze
#' @param observer1_col Name of column for observer 1
#' @param observer2_col Name of column for observer 2
#' @return A list with agreement statistics
calculate_agreement <- function(data, var_name, observer1_col, observer2_col) {
  
  # Extract ratings
  obs1 <- data[[observer1_col]]
  obs2 <- data[[observer2_col]]
  
  # Remove missing values
  valid_idx <- complete.cases(obs1, obs2)
  obs1 <- obs1[valid_idx]
  obs2 <- obs2[valid_idx]
  
  n_pairs <- length(obs1)
  
  # Calculate percentage agreement
  percent_agreement <- sum(obs1 == obs2) / n_pairs * 100
  
  results <- list(
    variable = var_name,
    n_pairs = n_pairs,
    percent_agreement = percent_agreement
  )
  
  return(results)
}

#' Calculate Cohen's Kappa for Categorical Variables
#'
#' @param observer1 Vector of ratings from observer 1
#' @param observer2 Vector of ratings from observer 2
#' @return Kappa statistic with confidence interval
calculate_kappa <- function(observer1, observer2) {
  require(irr)
  
  # Create matrix for kappa calculation
  ratings_matrix <- cbind(observer1, observer2)
  
  # Calculate Cohen's Kappa
  kappa_result <- kappa2(ratings_matrix, weight = "unweighted")
  
  return(kappa_result)
}

#' Calculate Weighted Kappa for Ordinal Variables
#'
#' @param observer1 Vector of ratings from observer 1
#' @param observer2 Vector of ratings from observer 2
#' @return Weighted kappa statistic
calculate_weighted_kappa <- function(observer1, observer2) {
  require(irr)
  
  # Create matrix for kappa calculation
  ratings_matrix <- cbind(observer1, observer2)
  
  # Calculate Weighted Kappa
  kappa_result <- kappa2(ratings_matrix, weight = "squared")
  
  return(kappa_result)
}

#' Calculate Intraclass Correlation Coefficient (ICC)
#'
#' @param observer1 Numeric vector from observer 1
#' @param observer2 Numeric vector from observer 2
#' @param icc_type Type of ICC (default: "ICC(2,1)" for two-way random, single measures)
#' @return ICC with confidence intervals
calculate_icc <- function(observer1, observer2, icc_type = "ICC(2,1)") {
  require(psych)
  
  # Create data frame with both observers
  ratings_df <- data.frame(obs1 = observer1, obs2 = observer2)
  
  # Calculate ICC
  icc_result <- ICC(ratings_df)
  
  return(icc_result)
}

#' Create Bland-Altman Plot
#'
#' @param observer1 Numeric vector from observer 1
#' @param observer2 Numeric vector from observer 2
#' @param var_name Name of the variable for plot title
#' @return ggplot object
create_bland_altman_plot <- function(observer1, observer2, var_name = "Measurement") {
  require(ggplot2)
  
  # Calculate mean and difference
  mean_val <- (observer1 + observer2) / 2
  diff_val <- observer1 - observer2
  
  # Calculate limits of agreement
  mean_diff <- mean(diff_val, na.rm = TRUE)
  sd_diff <- sd(diff_val, na.rm = TRUE)
  upper_loa <- mean_diff + 1.96 * sd_diff
  lower_loa <- mean_diff - 1.96 * sd_diff
  
  # Create data frame
  ba_data <- data.frame(
    mean = mean_val,
    difference = diff_val
  )
  
  # Create plot
  p <- ggplot(ba_data, aes(x = mean, y = difference)) +
    geom_point(alpha = 0.6, size = 2) +
    geom_hline(yintercept = mean_diff, color = "blue", linetype = "dashed", size = 1) +
    geom_hline(yintercept = upper_loa, color = "red", linetype = "dashed", size = 1) +
    geom_hline(yintercept = lower_loa, color = "red", linetype = "dashed", size = 1) +
    geom_hline(yintercept = 0, color = "gray", linetype = "dotted") +
    labs(
      title = paste("Bland-Altman Plot:", var_name),
      x = "Mean of Two Observers",
      y = "Difference (Observer 1 - Observer 2)",
      caption = sprintf("Mean difference: %.2f\n95%% Limits of Agreement: %.2f to %.2f", 
                       mean_diff, lower_loa, upper_loa)
    ) +
    theme_minimal() +
    theme(plot.caption = element_text(hjust = 0))
  
  return(p)
}

#' Generate Summary Statistics Table
#'
#' @param data Data frame with measurements
#' @param variables Vector of variable names to summarize
#' @return Summary table
generate_summary_stats <- function(data, variables) {
  require(dplyr)
  
  summary_list <- lapply(variables, function(var) {
    if (var %in% names(data)) {
      values <- data[[var]]
      data.frame(
        Variable = var,
        N = sum(!is.na(values)),
        Mean = mean(values, na.rm = TRUE),
        SD = sd(values, na.rm = TRUE),
        Median = median(values, na.rm = TRUE),
        Min = min(values, na.rm = TRUE),
        Max = max(values, na.rm = TRUE)
      )
    }
  })
  
  summary_table <- do.call(rbind, summary_list)
  return(summary_table)
}

#' Interpret Kappa Value
#'
#' @param kappa_value Kappa statistic value
#' @return Character string with interpretation
interpret_kappa <- function(kappa_value) {
  if (kappa_value < 0) {
    return("Poor (Less than chance agreement)")
  } else if (kappa_value >= 0 && kappa_value <= 0.20) {
    return("Slight")
  } else if (kappa_value > 0.20 && kappa_value <= 0.40) {
    return("Fair")
  } else if (kappa_value > 0.40 && kappa_value <= 0.60) {
    return("Moderate")
  } else if (kappa_value > 0.60 && kappa_value <= 0.80) {
    return("Substantial")
  } else {
    return("Almost Perfect")
  }
}

#' Interpret ICC Value
#'
#' @param icc_value ICC statistic value
#' @return Character string with interpretation
interpret_icc <- function(icc_value) {
  if (icc_value < 0.5) {
    return("Poor")
  } else if (icc_value >= 0.5 && icc_value < 0.75) {
    return("Moderate")
  } else if (icc_value >= 0.75 && icc_value < 0.9) {
    return("Good")
  } else {
    return("Excellent")
  }
}
