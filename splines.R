# install.packages(c('splines', 'VGAM', 'gamlss', 'gam')) # nolint
# https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-019-0666-3#Sec1 # nolint
library(VGAM)
library(gamlss)
library(gam)
library(ggplot2)

set.seed(0)
n <- 400
x <- 0:(n - 1) / (n - 1)
f <- -3.5 + 0.2 * x^11 * (10 * (1 - x))^6 + 10 * (10 * x)^3 * (1 - x)^10
y <- f + rnorm(n, 0, sd = 2)

fit_gam <- gam(y ~ bs(x))
fit_vgam <- vgam(y ~ bs(x), uninormal)
fit_gamlss <- gamlss(y ~ bs(x), control = gamlss.control(trace = FALSE))

summary(fit_gam)
fit_gam$coefficients

gam_bs <- gam(y ~ bs(x))
gam_ns <- gam(y ~ ns(x, df = 3))
gam_bsk <- gam(y ~ bs(x, knots = seq(0, 1, by = .2)))
gam_nsk <- gam(y ~ ns(x, knots = seq(0.2, .8, by = .2)))

df <- data.frame(x, y,
        y_gambs = fit_gam$fitted.values,
        y_vgam = fit_vgam@fitted.values[, 1],
        y_gamlss = predict(fit_gamlss),
        y_gamns = gam_ns$fitted.values,
        y_bsk = gam_bsk$fitted.values,
        y_nsk = gam_nsk$fitted.values
        )

ggplot(df, aes(x, y)) + geom_point() +
    geom_line(aes(y = y_gambs, colour = "GAM BS")) +
    geom_line(aes(y = y_gamns, colour = "GAM NS")) +
    scale_color_manual("",
        breaks = c("GAM BS", "GAM NS"),
        values = c("#FF0000", "#0000FF"))
