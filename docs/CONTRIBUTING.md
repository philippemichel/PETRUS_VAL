# Contributing to PETRUS_VAL

Thank you for your interest in contributing to the PETRUS_VAL project!

## How to Contribute

### Reporting Issues

If you encounter bugs or have suggestions:

1. Check if the issue already exists in the GitHub Issues
2. If not, create a new issue with:
   - Clear description of the problem
   - Steps to reproduce (if applicable)
   - Expected vs. actual behavior
   - R version and package versions
   - Sample data (if relevant and de-identified)

### Suggesting Enhancements

We welcome suggestions for:
- Additional statistical methods
- New visualizations
- Improved documentation
- Code optimizations
- New features

Please open an issue to discuss before implementing major changes.

### Code Contributions

#### Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```

#### Development Guidelines

**Code Style:**
- Follow tidyverse style guide: https://style.tidyverse.org/
- Use meaningful variable and function names
- Comment complex logic
- Keep functions focused and modular

**R Code Standards:**
```r
# Good
calculate_kappa <- function(ratings_matrix) {
  # Calculate Fleiss' Kappa for multiple raters
  result <- kappam.fleiss(ratings_matrix)
  return(result$value)
}

# Add comments for complex operations
# Use snake_case for variables and functions
# Include function documentation
```

**Documentation:**
- Update README.md if adding new features
- Document new functions with comments
- Update relevant documentation in `docs/`
- Add examples for new functionality

**Testing:**
- Test your code with example data
- Verify that existing functionality still works
- Check for edge cases (missing data, small samples, etc.)

#### Making Changes

1. Make your changes in your feature branch
2. Test thoroughly with:
   ```r
   source("scripts/00_setup.R")
   source("scripts/01_interobserver_analysis.R")
   ```
3. Update documentation as needed
4. Commit with clear, descriptive messages:
   ```bash
   git commit -m "Add Bland-Altman plot function for continuous variables"
   ```

#### Submitting a Pull Request

1. Push your changes to your fork
2. Create a Pull Request (PR) to the main repository
3. In the PR description, include:
   - What changes were made
   - Why the changes are needed
   - How to test the changes
   - Any related issues

4. Wait for review and be responsive to feedback

### Documentation Contributions

Documentation improvements are always welcome:

- Fix typos or clarify unclear sections
- Add examples or tutorials
- Improve code comments
- Translate documentation (if applicable)

### Data Contributions

**Important**: Do NOT contribute actual patient data to the repository.

You may contribute:
- Example datasets (synthetic or heavily anonymized)
- Data validation scripts
- Data transformation utilities

## Code of Conduct

### Our Standards

- Be respectful and professional
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Respect differing viewpoints and experiences
- Accept responsibility and apologize for mistakes

### Unacceptable Behavior

- Harassment or discriminatory language
- Personal attacks or trolling
- Publishing private information without permission
- Other unprofessional conduct

## Questions?

- Open an issue for general questions
- Check existing documentation in `docs/`
- Review closed issues for similar questions

## Recognition

Contributors will be acknowledged in:
- Repository contributors list
- Publication acknowledgments (for significant contributions)
- Release notes

## Development Priorities

Current priorities for development:

1. **High Priority:**
   - Robust error handling
   - Additional agreement metrics
   - Automated report generation

2. **Medium Priority:**
   - Interactive visualizations
   - Subgroup analyses
   - Bootstrap confidence intervals

3. **Future Enhancements:**
   - Shiny web application
   - Multi-language support
   - Integration with other analysis tools

## Review Process

1. **Initial Review**: Maintainer checks basic requirements
2. **Technical Review**: Code quality and functionality
3. **Testing**: Verification with example data
4. **Documentation Review**: Clarity and completeness
5. **Approval**: Merge when all checks pass

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Your contributions help improve research quality and reproducibility.

---

**Questions?** Contact: Philippe MICHEL

**Last updated**: 2025-11-13
