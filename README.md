

# Differential Privacy Synthetic Data Generation

## Overview

This project investigates how histogram bin size affects the utility and disclosure risk of synthetic data generated using a differentially private histogram synthesizer.

The project was completed as part of an independent study in Statistical Data Privacy at Binghamton University.

Using a healthcare dataset containing 55,500 observations, I generated differentially private synthetic versions of continuous variables and evaluated the tradeoff between data utility and privacy protection.

---

## Objectives

- Implement a histogram-based differential privacy synthesizer in R
- Compare multiple histogram bin sizes
- Evaluate utility using Propensity Score Mean Squared Error (pMSE)
- Evaluate disclosure risk using
    - Expected Match Risk (EMR)
    - True Match Rate (TMR)
    - False Match Rate (FMR)
- Analyze how bin size impacts the privacy-utility tradeoff

---

## Dataset

This project uses the Healthcare Dataset available on Kaggle.


Download it here:

https://www.kaggle.com/datasets/prasad22/healthcare-dataset

---

## Methods

The workflow consists of:

1. Load and clean the healthcare dataset
2. Normalize continuous variables
3. Build histogram bins
4. Add Laplace noise for differential privacy
5. Generate synthetic observations
6. Compare synthetic and original distributions
7. Measure utility using pMSE
8. Measure disclosure risk using EMR, TMR, and FMR

---

## Results

### Billing Amount

- m = 100 produced the best balance between utility and privacy.
- Larger numbers of bins increased the effect of Laplace noise.
- Higher m slightly improved privacy but reduced utility.

### Age

- Age behaved differently because it is effectively discrete.
- Disclosure risk remained high regardless of bin size.
- Results suggest histogram synthesis is not ideal for highly constrained integer variables.

---

## Repository Structure

```

.
├── README.md
├── report/
│ └── Synthetic-Data-Project.pdf
├── src/
│ ├── synthesizer.R
│ ├── utility_metrics.R
│ ├── disclosure_metrics.R
│ └── analysis.R


```

---

## Technologies

- R
- ggplot2
- dplyr
- tidyr
- reshape2
- rmutil
- Differential Privacy
- Synthetic Data Generation

---

## Future Work

- Compare additional datasets
- Evaluate different privacy budgets (ε)
- Compare histogram synthesis with alternative synthetic data methods
- Extend to multivariate synthesis

---

## Author

Ayron Thomas

Statistics and Data Science

Binghamton University
