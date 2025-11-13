# Contributing to PETRUS_VAL

Thank you for your interest in contributing to the PETRUS_VAL study framework! This document provides guidelines for contributing to the project.

## Project Overview

PETRUS_VAL is a framework for conducting inter-observer validation studies in ultrasound reading quality. The project focuses on providing reliable, scientifically rigorous tools for clinical research.

## How to Contribute

### Reporting Issues

If you encounter a bug or have a suggestion:

1. Check if the issue already exists in the GitHub Issues
2. If not, create a new issue with:
   - Clear, descriptive title
   - Detailed description of the issue/suggestion
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - R version and package versions (if applicable)
   - Sample data or code (if relevant)

### Suggesting Enhancements

We welcome suggestions for:
- New statistical methods
- Additional visualizations
- Improved documentation
- Code optimization
- New features

Please open an issue to discuss before implementing major changes.

### Contributing Code

#### Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/PETRUS_VAL.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test thoroughly
6. Commit with clear messages
7. Push to your fork
8. Submit a pull request

#### Code Style

**R Code:**
- Use 2-space indentation
- Use `<-` for assignment, not `=`
- Function names: `snake_case`
- Variable names: `snake_case`
- Constants: `UPPER_SNAKE_CASE`
- Add Roxygen2 documentation for functions
- Include error handling
- Comment complex logic

**Example:**
```r
#' Calculate Agreement Statistic
#'
#' @param obs1 Vector of observer 1 ratings
#' @param obs2 Vector of observer 2 ratings
#' @return Numeric agreement value
calculate_agreement <- function(obs1, obs2) {
  # Validate inputs
  if (length(obs1) != length(obs2)) {
    stop("Observer vectors must have equal length")
  }
  
  # Calculate agreement
  agreement <- sum(obs1 == obs2) / length(obs1)
  
  return(agreement)
}
```

#### Documentation

- Update README.md if adding features
- Update QUICKSTART.md for user-facing changes
- Add comments to complex code
- Include examples in documentation
- Update STUDY_PROTOCOL.md if changing methodology

#### Testing

Before submitting:
- Test with the example data (`data/data_template.csv`)
- Test with edge cases (missing data, small samples, etc.)
- Verify outputs are correct
- Check that plots render correctly
- Ensure no errors or warnings

#### Commit Messages

Use clear, descriptive commit messages:

```
Add function for weighted Kappa calculation

- Implements quadratic weighting for ordinal variables
- Includes confidence interval calculation
- Adds unit tests
```

### Pull Request Process

1. **Before Submitting:**
   - Ensure code follows style guidelines
   - Test thoroughly
   - Update documentation
   - Rebase on latest main branch

2. **Pull Request Description:**
   - Clearly describe what changes were made
   - Explain why the changes are needed
   - Reference any related issues
   - Include testing details

3. **Review Process:**
   - Maintainers will review your PR
   - Address any feedback
   - Once approved, your PR will be merged

## Development Guidelines

### Adding New Statistical Methods

When adding new methods:

1. Implement in `R/functions.R`
2. Add Roxygen2 documentation
3. Update `scripts/03_analysis.R` to use the method
4. Add interpretation guidelines
5. Include references to academic papers
6. Update `STUDY_PROTOCOL.md` methodology section
7. Add example to `example_workflow.R`

### Adding New Visualizations

When adding plots:

1. Use ggplot2 for consistency
2. Follow the theme used in existing plots
3. Include informative labels and titles
4. Add plot saving functionality
5. Update documentation
6. Include example in workflow

### Improving Documentation

Documentation improvements are always welcome:

- Fix typos or unclear explanations
- Add examples
- Improve organization
- Translate to other languages
- Add troubleshooting tips

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Accept responsibility for mistakes
- Prioritize the community's best interests

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Publishing others' private information
- Unprofessional conduct

## Questions?

- Open an issue for project-related questions
- Check existing documentation first
- Be specific and provide context

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

## Recognition

Contributors will be:
- Listed in the project README
- Acknowledged in release notes
- Credited in academic publications (for significant contributions)

## Areas Where We Need Help

Current priorities:

- [ ] Additional validation with real clinical data
- [ ] Performance optimization for large datasets
- [ ] Multilingual documentation
- [ ] Additional visualization options
- [ ] Shiny app interface
- [ ] Automated report generation improvements
- [ ] Unit testing framework

## Getting Help

If you need help contributing:

1. Read the documentation thoroughly
2. Check existing issues and pull requests
3. Open an issue with your question
4. Be patient and respectful

## Development Setup

### Prerequisites

- R version 4.0 or higher
- RStudio (recommended)
- Git

### Installation

```r
# Install development dependencies
install.packages(c(
  "tidyverse", "irr", "psych", "blandr",
  "knitr", "rmarkdown", "readxl", "janitor",
  "kableExtra", "devtools", "roxygen2", "testthat"
))
```

### Running Tests

```r
# Source the functions
source("R/functions.R")

# Run example workflow
source("example_workflow.R")

# Check that plots are generated
list.files("figures/")
```

## Version Control

- Main branch: stable, production-ready code
- Feature branches: new features under development
- Tag releases with semantic versioning (v1.0.0)

## Release Process

1. Update version number
2. Update CHANGELOG.md
3. Test thoroughly
4. Create release tag
5. Update documentation
6. Announce release

---

Thank you for contributing to PETRUS_VAL! Your help makes clinical research better for everyone.
