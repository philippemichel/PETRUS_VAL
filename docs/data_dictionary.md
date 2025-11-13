# Data Dictionary

## Overview

This document describes the structure and variables used in the PETRUS_VAL inter-observer validation study.

## Data Structure

The data should be organized in **long format** with one row per observation (reading × observer combination).

## Variables

### Identifier Variables

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `reading_id` | Character | Unique identifier for each ultrasound reading | US001, US002, ... |
| `observer_id` | Character | Anonymous identifier for each observer | OBS1, OBS2, OBS3 |

### Quality Assessment Variables

#### Technical Quality
Assessment of the technical aspects of the ultrasound acquisition.

| Variable | Type | Scale | Description |
|----------|------|-------|-------------|
| `technical_quality` | Categorical | Excellent / Good / Fair / Poor | Overall technical quality of the ultrasound |
| `image_clarity` | Categorical | Excellent / Good / Fair / Poor | Clarity and resolution of the image |
| `anatomical_views` | Categorical | Adequate / Inadequate | Whether appropriate anatomical views were obtained |

**Definitions:**
- **Excellent**: Optimal image quality, all necessary views clearly visible
- **Good**: Minor technical issues but diagnostic quality maintained
- **Fair**: Noticeable technical issues that may affect interpretation
- **Poor**: Significant technical issues limiting diagnostic value

#### Diagnostic Quality
Assessment of the adequacy for clinical interpretation.

| Variable | Type | Scale | Description |
|----------|------|-------|-------------|
| `diagnostic_quality` | Categorical | Excellent / Good / Fair / Poor | Quality for diagnostic purposes |
| `adequacy` | Binary | Yes / No or 1 / 0 | Whether the study is adequate for clinical interpretation |
| `interpretability` | Categorical | Fully / Partially / Not interpretable | Level of interpretability |

#### Overall Quality Score
Composite assessment of overall quality.

| Variable | Type | Scale | Description |
|----------|------|-------|-------------|
| `overall_quality` | Continuous | 1-10 | Overall quality score (1=worst, 10=best) |
| `confidence_score` | Continuous | 1-5 | Observer's confidence in their assessment |

### Optional Variables

| Variable | Type | Description |
|----------|------|-------------|
| `comments` | Text | Free-text comments or notes |
| `assessment_date` | Date | Date of assessment (use anonymous dates if possible) |
| `assessment_duration` | Numeric | Time taken for assessment (minutes) |
| `observer_experience` | Categorical | Junior / Senior / Expert |
| `ultrasound_type` | Categorical | Type or anatomical region (e.g., Cardiac, Abdominal) |

## Data Format Requirements

### File Format
- CSV (comma-separated values) preferred
- UTF-8 encoding
- Column headers in first row

### Missing Values
- Use `NA` for missing values in R
- Avoid empty cells; explicitly code as NA
- Document reasons for missing data

### Data Types
- **Categorical**: Use consistent spelling and capitalization
- **Numeric**: Use decimal points (.), not commas
- **Dates**: ISO 8601 format (YYYY-MM-DD)
- **Text**: Avoid special characters that may cause parsing issues

## Example Data

```csv
reading_id,observer_id,technical_quality,diagnostic_quality,overall_quality,adequacy
US001,OBS1,Good,Good,7.5,Yes
US001,OBS2,Excellent,Excellent,8.5,Yes
US001,OBS3,Good,Fair,7.0,Yes
US002,OBS1,Fair,Fair,5.5,No
US002,OBS2,Fair,Good,6.0,Yes
US002,OBS3,Poor,Fair,4.5,No
```

## Data Validation Checks

Before analysis, verify:
1. All reading IDs are unique within the dataset
2. Each reading has the same number of observer assessments
3. All observer IDs are consistent (no typos)
4. Ratings fall within expected ranges
5. No unexpected missing patterns
6. Date formats are consistent (if used)

## Coding Guidelines

### For Categorical Variables
- Use consistent capitalization (recommend: Excellent, Good, Fair, Poor)
- Avoid abbreviations
- No leading/trailing spaces

### For Numeric Variables
- Ensure values are within valid ranges
- Check for outliers that may indicate data entry errors
- Use appropriate decimal precision

## Variable Naming Conventions

- Use lowercase with underscores (snake_case)
- Be descriptive but concise
- Avoid special characters
- No spaces in variable names

## Study-Specific Considerations

Adapt this data dictionary based on:
- Specific ultrasound types being evaluated
- Institutional quality standards
- Regulatory requirements
- Study objectives

## Version History

- Version 1.0 (2025-11-13): Initial data dictionary
