# PETRUS_VAL Study Protocol

## Inter-observer Validation of Ultrasound Reading Quality

### Version 1.0 | Date: 2025-11-13

---

## 1. Study Overview

### 1.1 Title
Inter-observer Validation of Ultrasound Reading Quality

### 1.2 Study Acronym
PETRUS_VAL

### 1.3 Study Type
Clinical validation study - Inter-observer reliability assessment

### 1.4 Study Phase
Validation study (non-interventional)

---

## 2. Background and Rationale

### 2.1 Background
Ultrasound imaging is widely used in clinical practice for diagnostic purposes. The quality and interpretation of ultrasound images can vary between observers, which may affect clinical decision-making. Establishing the reliability of ultrasound readings is crucial for ensuring consistent and accurate diagnoses.

### 2.2 Rationale
This study aims to quantify the inter-observer agreement in ultrasound reading quality assessments. Understanding the level of agreement between observers will help:
- Identify areas requiring standardization
- Inform training requirements
- Establish reliability benchmarks
- Support quality assurance programs

---

## 3. Study Objectives

### 3.1 Primary Objective
To assess inter-observer agreement in ultrasound reading quality between two or more independent observers.

### 3.2 Secondary Objectives
1. To identify specific ultrasound parameters with high and low inter-observer agreement
2. To quantify reliability using appropriate statistical measures (Kappa, ICC)
3. To characterize systematic bias between observers
4. To provide recommendations for standardization and training

---

## 4. Study Design

### 4.1 Design Type
Cross-sectional validation study with paired observations

### 4.2 Study Population
Ultrasound images or recordings collected from clinical practice

### 4.3 Sample Size
Sample size should be adequate for:
- Cohen's Kappa: Minimum 30-50 paired observations
- ICC: Minimum 30 subjects for moderate to good reliability estimates
- Recommended: 50-100 paired observations for robust estimates

### 4.4 Observer Qualifications
- All observers should be qualified healthcare professionals
- Experience level should be documented
- Observers should be blinded to each other's assessments

---

## 5. Study Procedures

### 5.1 Data Collection

#### 5.1.1 Observer Independence
- Each observer assesses images independently
- No communication between observers during assessment period
- Observers are blinded to clinical outcomes and other observer ratings

#### 5.1.2 Assessment Timing
- Ideally, assessments should be performed within a short time frame
- Order of image presentation should be randomized when possible

#### 5.1.3 Variables to Assess

**Categorical Variables:**
- Image quality ratings (Poor, Fair, Good, Excellent)
- Presence/absence of specific findings
- Diagnostic classifications

**Ordinal Variables:**
- Quality scores (e.g., 1-10 scale)
- Severity ratings

**Continuous Variables:**
- Quantitative measurements (volumes, distances, thicknesses)
- Timing measurements

### 5.2 Data Management

#### 5.2.1 Data Entry
- Double entry verification recommended for critical variables
- Use of standardized forms or electronic data capture

#### 5.2.2 Data Quality
- Range checks for continuous variables
- Consistency checks between related variables
- Regular monitoring of data completeness

---

## 6. Statistical Analysis

### 6.1 Analysis Population
All paired observations with complete data for each variable of interest

### 6.2 Statistical Methods

#### 6.2.1 Descriptive Statistics
- Sample characteristics
- Distribution of measurements by observer
- Missing data summary

#### 6.2.2 Agreement Statistics

**For Categorical Variables:**
- Percentage agreement
- Cohen's Kappa (κ) with 95% confidence intervals
- Confusion matrices

**For Ordinal Variables:**
- Weighted Kappa (quadratic weights) with 95% confidence intervals

**For Continuous Variables:**
- Intraclass Correlation Coefficient (ICC) - Two-way random effects, single rater ICC(2,1)
- Pearson correlation coefficient
- Mean difference and standard deviation of differences
- Bland-Altman plots with limits of agreement

#### 6.2.3 Interpretation Criteria

**Cohen's Kappa:**
- < 0.00: Poor
- 0.00-0.20: Slight
- 0.21-0.40: Fair
- 0.41-0.60: Moderate
- 0.61-0.80: Substantial
- 0.81-1.00: Almost perfect

**ICC:**
- < 0.50: Poor
- 0.50-0.75: Moderate
- 0.75-0.90: Good
- > 0.90: Excellent

### 6.3 Software
- R version 4.0 or higher
- Key packages: irr, psych, tidyverse

### 6.4 Handling Missing Data
- Complete case analysis for each variable
- Proportion of missing data will be reported
- Pattern of missingness will be examined

---

## 7. Quality Assurance

### 7.1 Observer Training
- Standardized protocol for assessments
- Training session with example cases
- Pilot testing with feedback

### 7.2 Data Quality Control
- Regular data quality checks
- Verification of data entry
- Monitoring of completion rates

---

## 8. Ethical Considerations

### 8.1 Patient Privacy
- All data should be de-identified
- Patient identifiers replaced with study codes
- Compliance with local data protection regulations

### 8.2 Informed Consent
- Appropriate consent for use of clinical data
- Ethics committee approval as required

---

## 9. Timeline

### 9.1 Study Phases
1. **Preparation**: Protocol development, observer training
2. **Data Collection**: Independent assessments by observers
3. **Data Management**: Data entry and quality checks
4. **Analysis**: Statistical analysis of agreement
5. **Reporting**: Manuscript preparation and dissemination

---

## 10. Reporting

### 10.1 Report Contents
- Study objectives and methods
- Sample characteristics
- Agreement statistics with confidence intervals
- Visual displays (Bland-Altman plots, scatter plots)
- Interpretation and recommendations

### 10.2 Guidelines
- Follow GRRAS (Guidelines for Reporting Reliability and Agreement Studies)
- Include STROBE checklist items as applicable

---

## 11. References

1. Cohen J. A coefficient of agreement for nominal scales. Educational and Psychological Measurement. 1960;20(1):37-46.

2. Landis JR, Koch GG. The measurement of observer agreement for categorical data. Biometrics. 1977;33(1):159-174.

3. Shrout PE, Fleiss JL. Intraclass correlations: uses in assessing rater reliability. Psychological Bulletin. 1979;86(2):420-428.

4. Bland JM, Altman DG. Statistical methods for assessing agreement between two methods of clinical measurement. Lancet. 1986;1(8476):307-310.

5. Koo TK, Li MY. A Guideline of Selecting and Reporting Intraclass Correlation Coefficients for Reliability Research. Journal of Chiropractic Medicine. 2016;15(2):155-163.

6. Lucas NP, Macaskill P, Irwig L, Bogduk N. The development of a quality appraisal tool for studies of diagnostic reliability (QAREL). Journal of Clinical Epidemiology. 2010;63(8):854-861.

7. Kottner J, Audigé L, Brorson S, et al. Guidelines for Reporting Reliability and Agreement Studies (GRRAS) were proposed. Journal of Clinical Epidemiology. 2011;64(1):96-106.

---

## 12. Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-13 | Study Team | Initial protocol |

---

## 13. Appendices

### Appendix A: Data Collection Form
See `data/data_template.csv` for expected data structure

### Appendix B: Statistical Analysis Code
See `scripts/` directory for analysis scripts

### Appendix C: Report Template
See `reports/validation_report.Rmd` for report template
