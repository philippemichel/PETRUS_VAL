# PETRUS_VAL

## Inter-observer Validation of Ultrasound Reading Quality

### Project Overview

This repository contains the code and documentation for a clinical study evaluating the inter-observer reliability and agreement in ultrasound reading quality assessment.

### Study Objectives

The primary objective of this study is to assess the agreement between multiple observers when evaluating the quality of ultrasound readings. This validation study aims to:

1. Measure inter-observer reliability using appropriate statistical methods
2. Identify areas of strong and weak agreement between observers
3. Establish quality standards for ultrasound reading interpretation

### Study Design

- **Type**: Inter-observer validation study
- **Primary Endpoints**: Inter-observer agreement metrics (Cohen's Kappa, Intraclass Correlation Coefficient)
- **Data Collection**: Multiple observers independently rate ultrasound readings

### Repository Structure

```
.
├── data/              # Data files (not tracked in git for privacy)
├── scripts/           # R scripts for data analysis
├── docs/              # Study documentation and protocols
├── results/           # Analysis results and figures
└── README.md          # This file
```

### Statistical Analysis

The study employs several statistical methods to assess inter-observer agreement:

- **Cohen's Kappa**: For categorical assessments
- **Intraclass Correlation Coefficient (ICC)**: For continuous measurements
- **Bland-Altman plots**: For visual assessment of agreement
- **Percentage agreement**: For basic concordance metrics

### Requirements

- R (>= 4.0.0)
- Required R packages:
  - `tidyverse`: Data manipulation and visualization
  - `irr`: Inter-rater reliability measures
  - `psych`: ICC calculations
  - `ggplot2`: Plotting
  - `knitr`: Report generation
  - `rmarkdown`: Document generation

### Installation

```r
# Install required packages
install.packages(c("tidyverse", "irr", "psych", "ggplot2", "knitr", "rmarkdown"))
```

### Usage

1. Place your data files in the `data/` directory
2. Run the analysis scripts in the `scripts/` directory
3. View results in the `results/` directory

### Data Privacy

All patient data must be de-identified before analysis. Raw data files are not tracked in version control (see `.gitignore`).

### License

MIT License - see LICENSE file for details

### Contact

Philippe MICHEL

### Citation

If you use this code or methodology, please cite appropriately (citation details to be added upon publication).