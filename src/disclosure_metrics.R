```{r}
CalculateKeyQuantities_cont <- function(condata, syndata,
                                        unsyn.vars, syn.vars,
                                        n, r){
  condata <- condata
  syndata <- syndata
  n <- n
  c_vector <- rep(NA, n)
  T_vector <- rep(NA, n)
  for (i in 1:n){
    radius <- r*eval(parse(text=paste("condata$",syn.vars,"[i]")))
    match <- (eval(parse(text=paste("syndata$",syn.vars,
                                    "<=condata$",syn.vars,
                                    "[i]+",radius,sep="",
                                    collapse="&")))&
                eval(parse(text=paste("syndata$",syn.vars,
                                      ">=condata$",syn.vars,
                                      "[i]-",radius,sep="",
                                      collapse="&")))&
                eval(parse(text=paste("condata$",unsyn.vars,
                                      "[i]==syndata$",
                                      unsyn.vars,sep="",
                                      collapse="&"))))
    match.prob <- ifelse(match, 1/sum(match), 0)
    if (max(match.prob) > 0){
      c_vector[i] <- length(match.prob[match.prob == max(match.prob)])
    }
    else
      c_vector[i] <- 0
    T_vector[i] <- is.element(i, rownames(condata)[match.prob == max(match.prob)])
  }
  K_vector <- (c_vector * T_vector == 1)
  F_vector <- (c_vector * (1 - T_vector) == 1)
  s <- length(c_vector[c_vector == 1 & is.na(c_vector) == FALSE])
  res_r <- list(c_vector = c_vector,
                T_vector = T_vector,
                K_vector = K_vector,
                F_vector = F_vector,
                s = s)
  return(res_r)
}

IdentificationRiskCal <- function(c_vector, T_vector,
                                  K_vector, F_vector,
                                  s, N){
  nonzero_c_index <- which(c_vector > 0)
  EMR <- sum(1/c_vector[nonzero_c_index] * T_vector[nonzero_c_index])
  TMR <- sum(na.omit(K_vector))/N
  FMR <- sum(na.omit(F_vector))/s
  res_r <- list(EMR = EMR,
                TMR = TMR,
                FMR = FMR)
  return(res_r)
}

```
