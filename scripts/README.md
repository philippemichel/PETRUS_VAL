# Scripts Directory

## Overview

This directory contains R scripts and R Markdown documents for analyzing inter-observer agreement in the ultrasound reading quality validation study.

## Files

### 00_setup.R
Setup script for installing required R packages and preparing the environment.

**Usage:**
```r
source("scripts/00_setup.R")
```

### 01_interobserver_analysis.R
Main analysis script for calculating inter-observer agreement metrics.

**Features:**
- Loads and prepares data
- Calculates Cohen's Kappa / Fleiss' Kappa for categorical variables
- Calculates ICC for continuous variables
- Generates visualizations (heatmaps, Bland-Altman plots)
- Produces summary statistics

**Usage:**
```r
source("scripts/01_interobserver_analysis.R")
```

**Requirements:**
- Data file in `data/data.csv` format
- Columns: `reading_id`, `observer_id`, rating variables

### 02_analysis_report.Rmd
R Markdown template for generating comprehensive analysis reports.

**Features:**
- Executive summary
- Detailed statistical analysis
- Visualizations
- Interpretation guidelines
- Export to HTML or PDF

**Usage:**
```r
rmarkdown::render("scripts/02_analysis_report.Rmd", 
                  output_file = "../results/analysis_report.html")
```

### 03_test_example.R
Test script that demonstrates the analysis workflow using the included example data.

**Features:**
- Loads and analyzes example data
- Calculates Kappa for categorical variables
- Calculates ICC for continuous variables
- Provides interpretation of results
- Useful for learning and verification

**Usage:**
```r
source("scripts/03_test_example.R")
```

## Workflow

1. **Setup environment**
   ```r
   source("scripts/00_setup.R")
   ```

2. **Prepare your data**
   - Place de-identified data in `data/data.csv`
   - Ensure columns match template structure
   - Verify no missing observer IDs or reading IDs

3. **Run analysis**
   ```r
   source("scripts/01_interobserver_analysis.R")
   ```
   Or modify the script to work with your specific data structure

4. **Generate report**
   ```r
   rmarkdown::render("scripts/02_analysis_report.Rmd")
   ```

## Customization

### Modifying for Your Data

1. Update variable names in scripts to match your data columns
2. Adjust rating scales (categorical vs. continuous)
3. Modify interpretation thresholds if needed
4. Add study-specific analyses

### Adding New Analyses

- Create new R scripts with numeric prefixes (e.g., `03_subgroup_analysis.R`)
- Document new scripts in this README
- Follow the existing code style and structure

## Output

All results are saved to the `results/` directory:
- Plots: PNG format
- Reports: HTML or PDF format
- Tables: CSV format (if exported)

## Troubleshooting

### Common Issues

**Missing packages:**
```r
source("scripts/00_setup.R")
```

**Data loading errors:**
- Check file path is correct
- Verify CSV format (comma-separated)
- Ensure no special characters in column names

**Analysis errors:**
- Check for missing values
- Verify observer IDs are consistent
- Ensure adequate sample size (minimum 30 readings recommended)

## Statistical Interpretation Guide

### Kappa Values
- < 0.20: Poor agreement
- 0.21-0.40: Fair agreement
- 0.41-0.60: Moderate agreement
- 0.61-0.80: Good agreement
- 0.81-1.00: Excellent agreement

### ICC Values
- < 0.50: Poor reliability
- 0.50-0.75: Moderate reliability
- 0.75-0.90: Good reliability
- > 0.90: Excellent reliability

## References

See `docs/study_protocol.md` for detailed methodology and references.
