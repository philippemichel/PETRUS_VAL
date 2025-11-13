# Results Directory

## Overview

This directory contains output files from the inter-observer validation analysis, including plots, tables, and reports.

## File Types

### Plots
- `heatmap_*.png`: Agreement heatmaps showing pairwise observer agreement
- `bland_altman_*.png`: Bland-Altman plots for continuous variables
- `distribution_*.png`: Distribution plots of ratings by observer

### Reports
- `analysis_report.html`: Comprehensive HTML report with all analyses
- `analysis_report.pdf`: PDF version of the analysis report (if generated)

### Tables
- `agreement_metrics.csv`: Summary table of all agreement metrics
- `descriptive_stats.csv`: Descriptive statistics by observer

## File Naming Convention

Files are named descriptively to indicate their content:
- Variable name included in filename (e.g., `heatmap_technical_quality.png`)
- Date stamp may be added for version tracking
- Observer pairs specified for pairwise comparisons

## Viewing Results

### HTML Reports
Open `analysis_report.html` in any web browser to view the complete analysis with interactive features.

### Plot Files
PNG files can be viewed in any image viewer or inserted into presentations/manuscripts.

## Archiving

Consider archiving results with date stamps for version control:
```
results/
  2025-11-13/
    analysis_report.html
    heatmap_technical_quality.png
    ...
```

## Privacy Note

Result files may contain de-identified data visualizations. Ensure any shared files maintain anonymity of:
- Individual patients (reading IDs should be anonymous)
- Individual observers (use anonymous IDs)

## File Exclusions

Note: Result files are excluded from git tracking by default (see `.gitignore`).
Only this README file is version controlled.
