# Setup Script for PETRUS_VAL Study
# This script installs required R packages and prepares the environment
# Author: Philippe MICHEL
# Date: 2025-11-13

cat("=== PETRUS_VAL Study Setup ===\n\n")

# List of required packages
required_packages <- c(
  "tidyverse",    # Data manipulation and visualization
  "irr",          # Inter-rater reliability measures (Kappa)
  "psych",        # ICC calculations
  "ggplot2",      # Advanced plotting
  "knitr",        # Report generation
  "rmarkdown",    # R Markdown documents
  "kableExtra",   # Enhanced tables
  "gridExtra"     # Multiple plots arrangement
)

cat("Checking for required packages...\n")

# Function to check and install packages
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE, quietly = TRUE)) {
    cat(sprintf("Installing %s...\n", package))
    install.packages(package, dependencies = TRUE, repos = "https://cran.r-project.org")
    library(package, character.only = TRUE)
    cat(sprintf("%s installed successfully!\n", package))
  } else {
    cat(sprintf("%s is already installed.\n", package))
  }
}

# Install/check all required packages
for (pkg in required_packages) {
  install_if_missing(pkg)
}

cat("\n=== Package Installation Complete ===\n\n")

# Verify installation
cat("Verifying package versions...\n")
for (pkg in required_packages) {
  version <- packageVersion(pkg)
  cat(sprintf("  %s: version %s\n", pkg, version))
}

# Check R version
cat(sprintf("\nR version: %s\n", R.version.string))

# Create necessary directories if they don't exist
cat("\nChecking directory structure...\n")
dirs <- c("data", "scripts", "docs", "results")
for (dir in dirs) {
  if (!dir.exists(dir)) {
    dir.create(dir)
    cat(sprintf("  Created directory: %s\n", dir))
  } else {
    cat(sprintf("  Directory exists: %s\n", dir))
  }
}

# Set global options
options(stringsAsFactors = FALSE)
options(warn = 1)  # Print warnings as they occur

cat("\n=== Setup Complete ===\n")
cat("You can now run the analysis scripts.\n")
cat("Start with: source('scripts/01_interobserver_analysis.R')\n")
