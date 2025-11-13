# PETRUS_VAL

## Inter-observer Validation of Ultrasound Reading Quality - Clinical Study

### Overview

This repository contains the code and documentation for a clinical study assessing inter-observer agreement in ultrasound reading quality. The study aims to evaluate the reliability and consistency of ultrasound interpretations between different observers.

### Study Objectives

- Assess inter-observer agreement for ultrasound reading quality metrics
- Calculate agreement statistics (Cohen's Kappa, ICC) for categorical and continuous variables
- Visualize agreement patterns using Bland-Altman plots and other methods
- Generate comprehensive reports on inter-observer reliability

### Repository Structure

```
PETRUS_VAL/
├── data/
│   ├── raw/           # Raw data files (not committed to git)
│   └── processed/     # Processed/cleaned data
├── scripts/
│   ├── 01_data_import.R          # Data import and validation
│   ├── 02_data_preprocessing.R   # Data cleaning and preparation
│   └── 03_analysis.R              # Statistical analysis
├── R/
│   └── functions.R                # Custom R functions
├── reports/
│   └── validation_report.Rmd     # Main analysis report
└── figures/                       # Generated figures and plots
```

### Installation

#### Required R Packages

```r
install.packages(c(
  "tidyverse",    # Data manipulation and visualization
  "irr",          # Inter-rater reliability
  "psych",        # ICC calculations
  "blandr",       # Bland-Altman plots
  "knitr",        # Report generation
  "rmarkdown",    # Document rendering
  "readxl",       # Excel file reading
  "janitor"       # Data cleaning
))
```

### Usage

1. Place raw data files in `data/raw/`
2. Run analysis scripts in order:
   ```r
   source("scripts/01_data_import.R")
   source("scripts/02_data_preprocessing.R")
   source("scripts/03_analysis.R")
   ```
3. Generate the report:
   ```r
   rmarkdown::render("reports/validation_report.Rmd")
   ```

### Data Format

Expected data structure should include:
- Patient/Subject ID
- Observer ID (Observer 1, Observer 2, etc.)
- Measurement variables (both categorical and continuous)
- Date of assessment
- Any relevant metadata

See `data/data_template.csv` for the expected format.

### Statistical Methods

- **Cohen's Kappa**: For categorical agreement (e.g., quality ratings)
- **Intraclass Correlation Coefficient (ICC)**: For continuous measurements
- **Bland-Altman Analysis**: For assessing agreement and bias
- **Percentage Agreement**: Simple agreement percentages
- **Confidence Intervals**: 95% CI for all estimates

### License

See LICENSE file for details.

### Contact

For questions or issues, please open an issue on the GitHub repository.