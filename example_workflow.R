# PETRUS_VAL Example Workflow
# Complete end-to-end example using the template data

# This script demonstrates the complete workflow using the example data template
# Uncomment sections as needed and modify for your own data

cat("==========================================================\n")
cat("PETRUS_VAL - Example Workflow\n")
cat("Inter-observer Validation of Ultrasound Reading Quality\n")
cat("==========================================================\n\n")

# Install required packages if needed (run once)
# install.packages(c("tidyverse", "irr", "psych", "blandr", "knitr", 
#                    "rmarkdown", "readxl", "janitor", "kableExtra"))

# Load required packages
library(tidyverse)
library(irr)
library(psych)

# Source custom functions
source("R/functions.R")

cat("Step 1: Import Data\n")
cat("-------------------\n")

# Import the example data template
example_data <- read_csv("data/data_template.csv", show_col_types = FALSE)
cat("Loaded example data:", nrow(example_data), "rows\n")
cat("Columns:", paste(names(example_data), collapse = ", "), "\n\n")

# Display first few rows
cat("First few rows of data:\n")
print(head(example_data))
cat("\n")

cat("Step 2: Preprocess Data\n")
cat("-----------------------\n")

# Clean column names
example_data <- janitor::clean_names(example_data)

# Summarize observers
observer_summary <- example_data %>%
  group_by(observer_id) %>%
  summarise(
    n_assessments = n(),
    .groups = "drop"
  )
cat("Observer summary:\n")
print(observer_summary)
cat("\n")

# Reshape from long to wide format
measurement_vars <- c("quality_score", "bladder_volume_ml", 
                     "wall_thickness_mm", "residual_volume_ml",
                     "image_quality_category")

wide_data <- example_data %>%
  pivot_wider(
    id_cols = patient_id,
    names_from = observer_id,
    values_from = all_of(measurement_vars),
    names_sep = "_obs"
  )

cat("Data reshaped to wide format:", nrow(wide_data), "rows\n")
cat("Columns:", paste(names(wide_data), collapse = ", "), "\n\n")

cat("Step 3: Statistical Analysis\n")
cat("----------------------------\n\n")

# Initialize results storage
all_results <- list()

# ------------------------------
# Analysis 1: Quality Score (Ordinal)
# ------------------------------
cat(">>> Analysis 1: Quality Score (Ordinal) <<<\n")
cat("============================================\n")

obs1_quality <- wide_data$quality_score_obs1
obs2_quality <- wide_data$quality_score_obs2

# Remove missing
valid_idx <- complete.cases(obs1_quality, obs2_quality)
obs1_quality <- obs1_quality[valid_idx]
obs2_quality <- obs2_quality[valid_idx]

cat("N paired observations:", length(obs1_quality), "\n")
cat("Observer 1 mean:", round(mean(obs1_quality), 2), "\n")
cat("Observer 2 mean:", round(mean(obs2_quality), 2), "\n")

# Percentage agreement
percent_agree <- sum(obs1_quality == obs2_quality) / length(obs1_quality) * 100
cat("Percentage agreement:", round(percent_agree, 2), "%\n")

# Weighted Kappa (for ordinal data)
ratings_matrix <- cbind(obs1_quality, obs2_quality)
kappa_result <- kappa2(ratings_matrix, weight = "squared")
cat("\nWeighted Kappa:", round(kappa_result$value, 3), "\n")
cat("Interpretation:", interpret_kappa(kappa_result$value), "\n\n")

all_results[["Quality Score"]] <- list(
  type = "ordinal",
  n = length(obs1_quality),
  percent_agreement = percent_agree,
  kappa = kappa_result
)

# ------------------------------
# Analysis 2: Bladder Volume (Continuous)
# ------------------------------
cat(">>> Analysis 2: Bladder Volume (Continuous) <<<\n")
cat("================================================\n")

obs1_volume <- wide_data$bladder_volume_ml_obs1
obs2_volume <- wide_data$bladder_volume_ml_obs2

# Remove missing
valid_idx <- complete.cases(obs1_volume, obs2_volume)
obs1_volume <- obs1_volume[valid_idx]
obs2_volume <- obs2_volume[valid_idx]

cat("N paired observations:", length(obs1_volume), "\n")
cat("Observer 1 mean:", round(mean(obs1_volume), 2), "mL\n")
cat("Observer 2 mean:", round(mean(obs2_volume), 2), "mL\n")

# ICC
volume_df <- data.frame(obs1 = obs1_volume, obs2 = obs2_volume)
icc_result <- ICC(volume_df)
icc_value <- icc_result$results$ICC[2]  # ICC(2,1)
icc_lower <- icc_result$results$`lower bound`[2]
icc_upper <- icc_result$results$`upper bound`[2]

cat("\nICC(2,1):", round(icc_value, 3), "\n")
cat("95% CI: [", round(icc_lower, 3), ",", round(icc_upper, 3), "]\n")
cat("Interpretation:", interpret_icc(icc_value), "\n")

# Correlation
cor_result <- cor.test(obs1_volume, obs2_volume)
cat("\nPearson Correlation:", round(cor_result$estimate, 3), "\n")
cat("95% CI: [", round(cor_result$conf.int[1], 3), ",", 
    round(cor_result$conf.int[2], 3), "]\n")
cat("p-value:", format.pval(cor_result$p.value, digits = 3), "\n")

# Mean difference
diff <- obs1_volume - obs2_volume
mean_diff <- mean(diff)
sd_diff <- sd(diff)
cat("\nMean Difference (Obs1 - Obs2):", round(mean_diff, 2), "mL\n")
cat("SD of Differences:", round(sd_diff, 2), "mL\n")

# Bland-Altman plot
cat("\nGenerating Bland-Altman plot...\n")
ba_plot <- create_bland_altman_plot(obs1_volume, obs2_volume, "Bladder Volume (mL)")
print(ba_plot)

# Save plot
if (!dir.exists("figures")) dir.create("figures")
ggsave("figures/example_bland_altman_volume.png", ba_plot, 
       width = 8, height = 6, dpi = 300)
cat("Plot saved to: figures/example_bland_altman_volume.png\n\n")

all_results[["Bladder Volume"]] <- list(
  type = "continuous",
  n = length(obs1_volume),
  icc = icc_result,
  correlation = cor_result,
  mean_difference = mean_diff,
  sd_difference = sd_diff
)

# ------------------------------
# Analysis 3: Image Quality Category (Categorical)
# ------------------------------
cat(">>> Analysis 3: Image Quality Category (Categorical) <<<\n")
cat("=========================================================\n")

obs1_category <- wide_data$image_quality_category_obs1
obs2_category <- wide_data$image_quality_category_obs2

# Remove missing
valid_idx <- complete.cases(obs1_category, obs2_category)
obs1_category <- obs1_category[valid_idx]
obs2_category <- obs2_category[valid_idx]

cat("N paired observations:", length(obs1_category), "\n")

# Percentage agreement
percent_agree_cat <- sum(obs1_category == obs2_category) / length(obs1_category) * 100
cat("Percentage agreement:", round(percent_agree_cat, 2), "%\n")

# Cohen's Kappa
ratings_matrix_cat <- cbind(obs1_category, obs2_category)
kappa_result_cat <- kappa2(ratings_matrix_cat, weight = "unweighted")
cat("\nCohen's Kappa:", round(kappa_result_cat$value, 3), "\n")
cat("Interpretation:", interpret_kappa(kappa_result_cat$value), "\n")

# Confusion matrix
confusion_mat <- table(Observer1 = obs1_category, Observer2 = obs2_category)
cat("\nConfusion Matrix:\n")
print(confusion_mat)
cat("\n")

all_results[["Image Quality Category"]] <- list(
  type = "categorical",
  n = length(obs1_category),
  percent_agreement = percent_agree_cat,
  kappa = kappa_result_cat,
  confusion_matrix = confusion_mat
)

# ------------------------------
# Summary
# ------------------------------
cat("==========================================================\n")
cat("SUMMARY OF RESULTS\n")
cat("==========================================================\n\n")

summary_data <- data.frame(
  Variable = c("Quality Score", "Bladder Volume", "Image Quality Category"),
  Type = c("Ordinal", "Continuous", "Categorical"),
  N = c(all_results[["Quality Score"]]$n,
        all_results[["Bladder Volume"]]$n,
        all_results[["Image Quality Category"]]$n),
  Percent_Agreement = c(
    round(all_results[["Quality Score"]]$percent_agreement, 1),
    NA,
    round(all_results[["Image Quality Category"]]$percent_agreement, 1)
  )
)

# Add Kappa/ICC
summary_data$Agreement_Statistic <- c(
  paste0("Weighted κ = ", round(all_results[["Quality Score"]]$kappa$value, 3)),
  paste0("ICC = ", round(all_results[["Bladder Volume"]]$icc$results$ICC[2], 3)),
  paste0("κ = ", round(all_results[["Image Quality Category"]]$kappa$value, 3))
)

summary_data$Interpretation <- c(
  interpret_kappa(all_results[["Quality Score"]]$kappa$value),
  interpret_icc(all_results[["Bladder Volume"]]$icc$results$ICC[2]),
  interpret_kappa(all_results[["Image Quality Category"]]$kappa$value)
)

print(summary_data)
cat("\n")

# Save results
cat("Saving results...\n")
if (!dir.exists("data/processed")) dir.create("data/processed", recursive = TRUE)
saveRDS(all_results, "data/processed/example_results.rds")
write_csv(summary_data, "data/processed/example_summary.csv")

cat("\n==========================================================\n")
cat("Example workflow completed successfully!\n")
cat("==========================================================\n\n")

cat("Next steps:\n")
cat("1. Review the plots in the figures/ directory\n")
cat("2. Check the summary results in data/processed/example_summary.csv\n")
cat("3. Adapt this workflow for your own data\n")
cat("4. Generate the full report using: rmarkdown::render('reports/validation_report.Rmd')\n\n")
