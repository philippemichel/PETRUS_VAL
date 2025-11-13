# Changelog

All notable changes to the PETRUS_VAL project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-13

### Added
- Initial release of PETRUS_VAL framework
- Complete R project structure for inter-observer validation studies
- Statistical analysis functions:
  - Cohen's Kappa for categorical variables
  - Weighted Kappa for ordinal variables
  - Intraclass Correlation Coefficient (ICC) for continuous variables
  - Bland-Altman analysis and plots
  - Correlation analysis
  - Percentage agreement calculations
- Custom R functions library (`R/functions.R`) with 10 utility functions
- Three-stage analysis pipeline:
  - `scripts/01_data_import.R` - Data import from CSV/Excel
  - `scripts/02_data_preprocessing.R` - Data cleaning and transformation
  - `scripts/03_analysis.R` - Statistical analysis and visualization
- Example workflow (`example_workflow.R`) with complete demonstration
- Comprehensive documentation:
  - `README.md` - Project overview and quick reference
  - `STUDY_PROTOCOL.md` - Complete clinical study protocol
  - `QUICKSTART.md` - Step-by-step user guide
  - `IMPLEMENTATION_SUMMARY.md` - Technical implementation details
  - `data/README.md` - Data format and privacy guidelines
  - `CONTRIBUTING.md` - Contribution guidelines
- R Markdown report template (`reports/validation_report.Rmd`)
- Example data template (`data/data_template.csv`)
- Proper directory structure with privacy protection
- `.gitignore` configured to exclude sensitive data
- Automatic interpretation guidelines for Kappa and ICC values
- Publication-quality visualization functions

### Features
- Privacy protection (raw data excluded from git)
- Modular, maintainable code design
- Comprehensive error handling and validation
- Missing data handling
- Support for multiple observers
- Support for multiple variables
- Automatic plot generation and saving
- Results export to CSV and RDS formats
- Console output with progress indicators
- Statistical interpretation guidelines

### Documentation
- Over 15,000 words of documentation
- Code examples throughout
- Troubleshooting guides
- Academic references included
- GRRAS guideline compliance

### Dependencies
- tidyverse (data manipulation)
- irr (Cohen's Kappa)
- psych (ICC calculations)
- ggplot2 (visualization)
- readxl (Excel support)
- janitor (data cleaning)
- knitr (report generation)
- rmarkdown (document rendering)
- kableExtra (table formatting)
- blandr (Bland-Altman plots)

---

## Version History

### Version Numbering

This project uses [Semantic Versioning](https://semver.org/):

- **MAJOR** version: Incompatible API changes
- **MINOR** version: New functionality (backwards-compatible)
- **PATCH** version: Bug fixes (backwards-compatible)

### Future Releases

Planned for future versions:

- **1.1.0**: Support for more than 2 observers
- **1.2.0**: Shiny web interface
- **1.3.0**: Additional visualization options
- **2.0.0**: Integration with electronic data capture systems

---

## How to Update

To update to the latest version:

```bash
git pull origin main
```

Check this CHANGELOG for breaking changes before updating.

---

## Support

For issues or questions:
- Open an issue on GitHub
- Check the documentation
- Review example workflow

---

[1.0.0]: https://github.com/philippemichel/PETRUS_VAL/releases/tag/v1.0.0
