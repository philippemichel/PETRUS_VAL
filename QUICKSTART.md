# PETRUS_VAL Quick Start Guide

## Getting Started in 5 Steps

### Step 1: Install Required R Packages

Open R or RStudio and run:

```r
# Install required packages
install.packages(c(
  "tidyverse",    # Data manipulation and visualization
  "irr",          # Inter-rater reliability (Cohen's Kappa)
  "psych",        # ICC calculations
  "blandr",       # Bland-Altman plots
  "knitr",        # Report generation
  "rmarkdown",    # Document rendering
  "readxl",       # Excel file reading
  "janitor",      # Data cleaning
  "kableExtra"    # Table formatting
))
```

### Step 2: Prepare Your Data

Your data should be in one of these formats:

**Option A: Long format (one row per observation)**
```
patient_id, observer_id, assessment_date, variable1, variable2, ...
P001, 1, 2025-01-15, 8, 450, ...
P001, 2, 2025-01-15, 7, 455, ...
```

**Option B: Wide format (one row per patient)**
```
patient_id, var1_obs1, var1_obs2, var2_obs1, var2_obs2, ...
P001, 8, 7, 450, 455, ...
```

See `data/data_template.csv` for an example.

Place your data file in the `data/raw/` directory.

### Step 3: Import Your Data

Edit and run `scripts/01_data_import.R`:

```r
# Open the script
source("scripts/01_data_import.R")

# Import your data (uncomment and modify)
raw_data <- import_csv_data("data/raw/your_data.csv")

# Or from Excel
# raw_data <- import_excel_data("data/raw/your_data.xlsx", sheet = 1)

# Validate structure
required_columns <- c("patient_id", "observer_id", "assessment_date")
validate_data_structure(raw_data, required_columns)

# Save
saveRDS(raw_data, "data/processed/imported_data.rds")
```

### Step 4: Preprocess Your Data

Edit and run `scripts/02_data_preprocessing.R`:

```r
source("scripts/02_data_preprocessing.R")

# Load data
raw_data <- readRDS("data/processed/imported_data.rds")

# Clean data
cleaned_data <- clean_data(raw_data)

# Reshape from long to wide format (if needed)
measurement_vars <- c("quality_score", "bladder_volume_ml", "wall_thickness_mm")
wide_data <- reshape_for_comparison(
  cleaned_data, 
  id_col = "patient_id",
  observer_col = "observer_id",
  value_cols = measurement_vars
)

# Save
saveRDS(wide_data, "data/processed/preprocessed_data.rds")
```

### Step 5: Run the Analysis

Edit and run `scripts/03_analysis.R`:

```r
source("scripts/03_analysis.R")

# Load preprocessed data
paired_data <- readRDS("data/processed/preprocessed_data.rds")

# Define your variables to analyze
variables_to_analyze <- list(
  list(
    name = "Quality Score", 
    obs1 = "quality_score_obs1", 
    obs2 = "quality_score_obs2", 
    type = "ordinal"  # or "categorical" or "continuous"
  ),
  list(
    name = "Bladder Volume", 
    obs1 = "bladder_volume_ml_obs1", 
    obs2 = "bladder_volume_ml_obs2", 
    type = "continuous"
  )
)

# Run analyses
all_results <- list()
for (var in variables_to_analyze) {
  result <- analyze_interobserver_agreement(
    data = paired_data,
    var_name = var$name,
    obs1_col = var$obs1,
    obs2_col = var$obs2,
    var_type = var$type
  )
  all_results[[var$name]] <- result
}

# Compile summary
summary_table <- compile_results_summary(all_results)
print(summary_table)

# Save results
saveRDS(all_results, "data/processed/analysis_results.rds")
write_csv(summary_table, "data/processed/summary_results.csv")
```

## Generate the Report

Once analysis is complete, generate the HTML report:

```r
# Render the report
rmarkdown::render("reports/validation_report.Rmd")
```

The report will be saved as `reports/validation_report.html`.

## Understanding Your Results

### For Categorical/Ordinal Variables

**Cohen's Kappa / Weighted Kappa:**
- **< 0.20**: Slight agreement - Consider additional training
- **0.21-0.40**: Fair agreement - Moderate reliability
- **0.41-0.60**: Moderate agreement - Acceptable for screening
- **0.61-0.80**: Substantial agreement - Good reliability
- **> 0.80**: Almost perfect agreement - Excellent reliability

### For Continuous Variables

**ICC (Intraclass Correlation):**
- **< 0.50**: Poor reliability - Not acceptable
- **0.50-0.75**: Moderate reliability - May be acceptable with caution
- **0.75-0.90**: Good reliability - Acceptable for most purposes
- **> 0.90**: Excellent reliability - Highly reliable

**Bland-Altman Plots:**
- Points within limits of agreement (dotted lines) indicate good agreement
- Systematic bias is shown by the mean difference line
- Spread of points indicates variability in agreement

## Troubleshooting

### Issue: "Column not found" error
**Solution**: Check that your column names match exactly (case-sensitive). Use `names(your_data)` to see all column names.

### Issue: Too few observations
**Solution**: You need at least 30 paired observations for reliable statistics. Consider collecting more data.

### Issue: Many missing values
**Solution**: Review data collection procedures. Complete case analysis is used, so missing data reduces sample size.

### Issue: Perfect agreement (Kappa = 1.0)
**Solution**: This may indicate lack of variability in ratings. Verify that your data includes a range of cases.

### Issue: Negative Kappa values
**Solution**: This indicates agreement worse than chance. Review observer training and assessment protocols.

## Next Steps

1. **Review Results**: Examine agreement statistics and plots
2. **Identify Issues**: Note variables with low agreement
3. **Investigate**: Look for patterns in disagreements
4. **Improve**: Develop standardization protocols or additional training
5. **Re-validate**: Consider repeating study after improvements

## Need Help?

- Check the full documentation in `STUDY_PROTOCOL.md`
- Review the example data template in `data/data_template.csv`
- Open an issue on GitHub for specific questions

## Quick Reference: File Structure

```
PETRUS_VAL/
├── data/
│   ├── raw/              # Your raw data files (not in git)
│   ├── processed/        # Processed data (generated)
│   └── data_template.csv # Example data format
├── scripts/
│   ├── 01_data_import.R          # Step 3
│   ├── 02_data_preprocessing.R   # Step 4
│   └── 03_analysis.R              # Step 5
├── R/
│   └── functions.R                # Utility functions
├── reports/
│   └── validation_report.Rmd     # Report template
├── figures/                       # Generated plots
├── QUICKSTART.md                  # This file
├── STUDY_PROTOCOL.md              # Full protocol
└── README.md                      # Project overview
```
