library(tidyverse)
library(magrittr)
options(scipen = 1)

# wine dataset
# https://www.kaggle.com/uciml/red-wine-quality-cortez-et-al-2009

wine <- read.csv("./data/winequality-red.csv", stringsAsFactors = FALSE)
glimpse(wine)
# estimation through least squares
ls_lin_reg <- function(x, y) {
    b_1 <- sum((x - mean(x)) * (y - mean(y))) / sum((x - mean(x))^2)
    b_0 <- mean(y) - b_1 * mean(x)
    coefs <- list("b_1" = b_1, "b_0" = b_0)
    mse <- sum((y - mean(y))^2) / (length(y) - 2)
    summ <- list("coefs" = coefs, "mse" = mse)
    return(summ)
}

ls_lin_reg(wine$fixed.acidity, wine$pH)

# estimation through mle
# first, the intuition
y_s <- c(250, 265, 259)
# which distribution were these samples more likely drawn from?
d_1 <- dnorm(y_s, mean = 230, sd = 10)
d_2 <- dnorm(y_s, mean = 250, sd = 10)
prod(d_1)
prod(d_2)
# the product of these densities shows that distribution 2
# was more likely to have produced that sample

likelihood_est <- function(x) {
    s_mean <- mean(x)
    s_sd <- sd(x)
    LL <- function(x, mu, sig) {
        val <- dnorm(x, mu, sig, log = TRUE)
        ll <- sum(val)
        return(ll)
    }
    df <- data.frame(
        mu = seq(s_mean - 10 * s_sd,
                s_mean + 9 * s_sd,
                s_sd),
        sig = rep(s_sd, 20)

    )
    obs <- list(x)
    df$ll <- unlist(pmap(list(rep(obs, 20), df$mu, df$sig), LL))

    return(df)
}
likelihoods <- likelihood_est(y_s)
glimpse(likelihoods)
ggplot(likelihoods, aes(x = mu, y = ll)) +
    geom_line()


mod <- lm(pH ~ fixed.acidity, data = wine)
mod$coefficients