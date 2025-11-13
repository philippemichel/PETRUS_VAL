# Data Directory

## Overview

This directory contains data files for the inter-observer validation study. All data must be **de-identified** before being placed in this directory.

## Data Files

### data_template.csv
Template file showing the expected data structure for observer ratings.

**Columns:**
- `reading_id`: Unique identifier for each ultrasound reading (e.g., US001, US002)
- `observer_id`: Anonymous identifier for each observer (e.g., OBS1, OBS2)
- `technical_quality`: Rating of technical quality (scale: 1-5 or Excellent/Good/Fair/Poor)
- `diagnostic_quality`: Rating of diagnostic quality (scale: 1-5 or Excellent/Good/Fair/Poor)
- `overall_quality`: Overall quality rating (scale: 1-10 or categorical)
- `image_clarity`: Binary or categorical rating of image clarity
- `anatomical_views`: Assessment of anatomical views (Adequate/Inadequate)
- `adequacy`: Overall adequacy for clinical interpretation (Yes/No)
- `comments`: Optional free-text comments

### Example Data Formats

**Categorical ratings:**
```
Excellent, Good, Fair, Poor
```

**Numerical ratings:**
```
1-5 scale (1=Poor, 5=Excellent)
1-10 scale (continuous)
```

**Binary ratings:**
```
Yes/No
Adequate/Inadequate
1/0
```

## Data Privacy

⚠️ **IMPORTANT**: 
- All patient identifiers must be removed before data entry
- Use anonymous IDs for ultrasound readings
- Use anonymous IDs for observers
- Do not include dates that could identify patients
- Actual data files (*.csv, *.xlsx) are NOT tracked in git (see .gitignore)

## Data Entry Guidelines

1. Use consistent scales across all observers
2. Ensure each ultrasound reading is evaluated by all observers
3. Observers should work independently without discussion
4. Record ratings promptly after review
5. Include all observations (do not exclude outliers at data entry stage)

## Quality Control

- Check for missing values
- Verify observer IDs are consistent
- Ensure reading IDs match across observers
- Validate that ratings are within expected ranges
