# Quick Start Guide

## Getting Started with PETRUS_VAL

This guide will help you quickly set up and run the inter-observer validation analysis.

## Prerequisites

- R (version 4.0.0 or higher)
- RStudio (recommended but optional)
- Basic familiarity with R

## Installation Steps

### 1. Install R and RStudio

If you haven't already:
- Download R from: https://cran.r-project.org/
- Download RStudio from: https://www.rstudio.com/products/rstudio/download/

### 2. Clone or Download the Repository

```bash
git clone https://github.com/philippemichel/PETRUS_VAL.git
cd PETRUS_VAL
```

Or download and extract the ZIP file from GitHub.

### 3. Install Required Packages

Open R or RStudio and run:

```r
setwd("path/to/PETRUS_VAL")  # Set your working directory
source("scripts/00_setup.R")
```

This will automatically install all required packages.

## Running Your First Analysis

### Using Example Data

The repository includes example data to test the analysis pipeline:

```r
# 1. Load required libraries
library(tidyverse)
library(irr)
library(psych)

# 2. Load example data
data <- read.csv("data/example_data.csv")

# 3. View the data
head(data)
str(data)

# 4. Run a simple Kappa analysis
# Reshape for technical quality
library(tidyr)
tech_wide <- data %>%
  select(reading_id, observer_id, technical_quality) %>%
  pivot_wider(names_from = observer_id, values_from = technical_quality)

tech_matrix <- as.matrix(tech_wide[, -1])

# Calculate Fleiss' Kappa
kappam.fleiss(tech_matrix)
```

### Using Your Own Data

1. **Prepare your data file**
   - Format: CSV file
   - Required columns: `reading_id`, `observer_id`, and rating columns
   - See `data/data_template.csv` for structure
   - See `docs/data_dictionary.md` for detailed specifications

2. **Place data in the data directory**
   ```
   data/data.csv
   ```

3. **Modify the analysis script**
   
   Edit `scripts/01_interobserver_analysis.R`:
   
   ```r
   # Change line ~25 from:
   # data <- read.csv("data/data.csv")
   
   # To use your file:
   data <- read.csv("data/your_data_file.csv")
   ```

4. **Run the analysis**
   ```r
   source("scripts/01_interobserver_analysis.R")
   ```

## Generating Reports

### HTML Report

To generate a comprehensive HTML report:

```r
rmarkdown::render(
  "scripts/02_analysis_report.Rmd",
  output_file = "../results/analysis_report.html"
)
```

Then open `results/analysis_report.html` in your web browser.

### PDF Report

For PDF output (requires LaTeX):

```r
rmarkdown::render(
  "scripts/02_analysis_report.Rmd",
  output_format = "pdf_document",
  output_file = "../results/analysis_report.pdf"
)
```

## Understanding the Results

### Key Metrics

**Kappa Values (Categorical Variables):**
- < 0.20: Poor agreement
- 0.21-0.40: Fair agreement
- 0.41-0.60: Moderate agreement
- 0.61-0.80: Good agreement
- 0.81-1.00: Excellent agreement

**ICC Values (Continuous Variables):**
- < 0.50: Poor reliability
- 0.50-0.75: Moderate reliability
- 0.75-0.90: Good reliability
- > 0.90: Excellent reliability

### Output Files

Results are saved in the `results/` directory:
- **Plots**: PNG images showing agreement patterns
- **Reports**: HTML/PDF with complete analysis
- **Console output**: Summary statistics and metrics

## Common Tasks

### Task 1: Compare Two Observers Only

```r
# Filter for two specific observers
data_2obs <- data %>%
  filter(observer_id %in% c("OBS1", "OBS2"))

# Calculate Cohen's Kappa
library(irr)
ratings <- data_2obs %>%
  select(reading_id, observer_id, technical_quality) %>%
  pivot_wider(names_from = observer_id, values_from = technical_quality)

kappa2(ratings[, c("OBS1", "OBS2")])
```

### Task 2: Create Agreement Heatmap

```r
# See scripts/01_interobserver_analysis.R
# Use the create_agreement_heatmap() function
source("scripts/01_interobserver_analysis.R")

create_agreement_heatmap(
  data, 
  "technical_quality", 
  "results/heatmap_technical.png"
)
```

### Task 3: Create Bland-Altman Plot

```r
# For continuous variables
create_bland_altman(
  data, 
  "overall_quality", 
  "OBS1", 
  "OBS2", 
  "results/bland_altman.png"
)
```

## Troubleshooting

### Issue: Package Installation Fails

**Solution**: Install packages manually

```r
install.packages(c("tidyverse", "irr", "psych", "ggplot2"))
```

### Issue: Data Not Loading

**Check:**
1. File path is correct
2. CSV format (comma-separated)
3. Column names match expected format
4. No special characters in data

### Issue: Kappa Calculation Fails

**Common causes:**
1. Missing values in data
2. Inconsistent observer IDs
3. Different number of ratings per reading
4. Too few observations

**Solution**: Check data structure
```r
# Check for missing values
summary(data)

# Check observer consistency
table(data$observer_id)

# Check readings per observer
data %>% count(reading_id, observer_id)
```

## Next Steps

1. **Read the study protocol**: `docs/study_protocol.md`
2. **Review data dictionary**: `docs/data_dictionary.md`
3. **Customize scripts**: Modify for your specific study needs
4. **Explore visualizations**: Try different plot types and parameters

## Getting Help

- **Issues**: Open an issue on GitHub
- **Documentation**: Check the `docs/` directory
- **Script comments**: Read inline comments in R scripts

## Additional Resources

- R for Data Science: https://r4ds.had.co.nz/
- Inter-rater reliability package: https://cran.r-project.org/package=irr
- ggplot2 documentation: https://ggplot2.tidyverse.org/

---

**Last updated**: 2025-11-13
