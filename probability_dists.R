library(tidyverse)

# poisson
pois <- rpois(1000, lambda = 7)
# normal
norm <- rnorm(1000, mean = 0, sd = 1)
# binomial
bin <- rbinom(1000, 500, 0.5) / 500
# chisq
chisq <- rchisq(1000, df = 1, ncp = 0)

probs <- data.frame(pois, norm, bin, chisq)

ggplot(probs, aes(x = norm)) + geom_histogram(binwidth = 1)


# Feature of a random uniform with mean 0 and var 1.
nn <- 1e5
aa <- sqrt(3)
unif_1 <- runif(nn, -aa, aa) 
unif_2 <- runif(nn, -aa, aa)

scalar_diff <- function(k) {
    sum(2*unif_1 > unif_2)/nn
}

mean(sapply(1:1000, scalar_diff))
# prob 0.5

# make an unfair coin fair
unfair_coin <- function(p = 0.6, rep = 10) {
    res <- c()
    for (i in 1:rep) {
        new_flip <- TRUE
        while (new_flip) {
            flip <- rbinom(2, 1, p)
            if (sum(flip) == 1) {
                res[i] <- flip[2]
                new_flip <- FALSE
            }
        }
    }
    return(res)
}

mean(unfair_coin(p = 0.85, rep = 1000))

# Plot normal distribution

a <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 3, ncol = 2)
2 * a
