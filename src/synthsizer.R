```{r}
synthesize_dp <- function(data, column, m, a_min, a_max, eps = 1, seed = 730) {
  
y_vector <- data %>%
  pull({{ column }})
# Calculate the sample size
n <- data %>%
nrow()
# Create bounded confidential vector
y_vector_bounded <- (y_vector - a_min) / (a_max - a_min)
# Calculate the length of each bin
h <- 1 / m
# Create the bins
bins <- seq(0, 1, h)
# Calculate C_j's
C <- rep(0, m)
for (j in 1:m) {
  C[j] <- sum(
    y_vector_bounded >= bins[j] &
    (y_vector_bounded < bins[j + 1] | (j == m & y_vector_bounded == 1))
  )
}
# Set seed to obtain reproducible results
base::set.seed(seed)
# Sample vector
eta <- rmutil::rlaplace(n = m,
m = 0,
s = 1/eps)
# Create D vector
D <- C + eta
# Create D_tilde vector
D_tilde <- rep(0, m)
for (j in 1:m){
D_tilde[j] <- max(D[j], 0)
}
# Calculate q_hat_pert vector
q_hat_pert <- D_tilde/sum(D_tilde)
# Simulate DP microdata value within bounds
y_vector_bounded_star <- rep(NA, n)
for (i in 1:n){
bin_i <- which(stats::rmultinom(1, 1, q_hat_pert) == 1)
range_lower <- bins[bin_i]
range_upper <- bins[bin_i + 1]
obs_i <- runif(1, range_lower, range_upper)
y_vector_bounded_star[i] <- obs_i
}
# Create DP synthetic vector in its original scale
y_vector_star <- y_vector_bounded_star*(a_max - a_min) + a_min
# Combine two vectors in a single data frame
df <- tibble(
type = rep(c("Confidential", "DPsynthetic"), each = n),
vectors = c(y_vector, y_vector_star)
) %>%
mutate(type = factor(type,
levels = c("Confidential", "DPsynthetic")))
df_long <- reshape2::melt(df)
# Plot density distributions of the confidential and synthetic vectors
p <- ggplot2::ggplot(data = df_long, aes(value, colour = type,
linetype = type)) +
geom_density() +
scale_colour_manual(values = c("#E69F00", "#999999"),
                    guide = guide_legend(override.aes = list(
                      linetype = c(1, 2)))) +
scale_linetype_manual(values = c(1, 2), guide = "none") +
xlab(as.character(substitute(column))) +
theme_bw(base_size = 15, base_family = "") +
theme(legend.title = element_blank())

print(p)

#Store list of values for other uses 
invisible(list(
  m = m,
  eps = eps,
  a_min = a_min,
  a_max = a_max,
  y_star = y_vector_star,
  plot = p
))
}
```
