# Changelog

All notable changes to the PETRUS_VAL project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project structure for inter-observer validation study
- Comprehensive README with project overview and usage instructions
- Study protocol documentation
- Data dictionary with variable specifications
- Quick start guide for new users
- Contributing guidelines for collaborators
- R analysis scripts for inter-observer agreement:
  - Setup script (00_setup.R) for package installation
  - Main analysis script (01_interobserver_analysis.R) with Kappa and ICC calculations
  - R Markdown report template (02_analysis_report.Rmd)
  - Test script with example data (03_test_example.R)
- Data templates and example data (10 ultrasound readings, 3 observers)
- Results directory structure with README
- Comprehensive documentation in docs/ directory
- Privacy-conscious .gitignore configuration

### Statistical Methods Implemented
- Cohen's Kappa (for 2 observers)
- Fleiss' Kappa (for multiple observers)
- Intraclass Correlation Coefficient (ICC)
  - ICC(2,1): Single rater absolute agreement
  - ICC(2,k): Average rater absolute agreement
- Bland-Altman plots for continuous variables
- Agreement heatmaps for visualization
- Descriptive statistics by observer

### Features
- Support for categorical and continuous rating variables
- Automated interpretation of agreement metrics
- Visualization functions for results
- Data validation and quality checks
- Comprehensive documentation and examples

## [0.1.0] - 2025-11-13

### Added
- Initial repository setup
- MIT License
- Basic README
- R-specific .gitignore

---

## Version Numbering

- **Major version** (X.0.0): Significant changes, may break compatibility
- **Minor version** (0.X.0): New features, maintains compatibility
- **Patch version** (0.0.X): Bug fixes and minor improvements

## Categories

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security vulnerability fixes
