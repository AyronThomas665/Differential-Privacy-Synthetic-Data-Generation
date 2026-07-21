```{r}
calc_pMSE <- function(synthetic_vector, column) {
  
  n <- nrow(hcdata)
  
  # Create final synthetic data set
  synthetic_final <- hcdata %>%
    mutate({{ column }} := synthetic_vector)
  
  # Merge confidential and synthetic
  merged_data <- dplyr::bind_rows(
    hcdata,
    synthetic_final
  )
  
  # Add S indicator
  merged_data <- merged_data %>%
    mutate(S = c(rep(0, n), rep(1, n)))
  
  # Logistic regression with all relevant variables
  log_reg <- stats::glm(formula = S ~ (Age +
                                       Billing.Amount +
                                       Room.Number +
                                       as.factor(Gender) +
                                       as.factor(Blood.Type) +
                                       as.factor(Medical.Condition) +
                                       as.factor(Insurance.Provider) +
                                       as.factor(Admission.Type) +
                                       as.factor(Medication) +
                                       as.factor(Test.Results))^2,
                        family = "binomial",
                        data = merged_data)
  
  # Predicted probabilities
  pred <- stats::predict(log_reg, data = merged_data)
  probs <- exp(pred) / (1 + exp(pred))
  
  # Calculate pMSE
  pMSE <- 1/(2*n) * sum((probs - 1/2)^2)
  
  return(pMSE)
}
```
