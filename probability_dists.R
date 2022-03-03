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

ggplot(probs, aes(x = pois)) + geom_histogram(binwidth = 1)
