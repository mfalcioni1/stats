# Questions
## Statistics
+ In what situation would you consider mean over median?
    + Data is evenly dispersed, with few to no outliers.
+ For sample size n, the margin of error is 3. How many more samples do we need to make the margin of error 0.3?
    + 100 times, i.e. margin_of_error = z * sqrt(sd^2/n) if n = 25 then we need 2500 samples.
+ What is the assumption of error in linear regression?
    + Errors (residuals) are approximately normally distributed
+ Given data from two product campaigns, how could you do an A/B test if we see a 3% increase for one product?
    + This changes based on the metric of interest. Variance is calculated differently for proportions vs. means, so depending on the metric we will execute a different testing precedure. In either case, we can conservatively use a t-distribution to calculate our p-value. If we know the population variance, and have a large enough sample size we can assume normality according to the central-limit theorem and apply a z-distribution instead.

## Probability
+ I have a deck and take one card at random. What is the probability you guess it right?
    + Assuming it is a normal deck of cards, 1/52.
+ Explain a probability distribution that is not normal and how to apply that.
    + A poisson distribution can often times be used to estimate the number of events in a fixed interval of time. Lambda is the rate parameter, and it is the expected number of events in that period of time. This can be used to predict the probability of an increase in unit sales in a future time period.
+ Given uniform distributions X and Y and the mean 0 and standard deviation 1 for both, what’s the probability of 2X > Y? (Solution)
    + 0.5, this is an odd question but since the mean of the two distributions is 0 multiplying by a constant will not change that. The fact that the distribution is uniform, half of the data lives above and below the mean. Therefore, the probability remains as if we did not multiply at all.
+ There are four people in an elevator and four floors in a building. What’s the probability that each person gets off on a different floor?
    + Thinking through it consecutively, the first person has a 1/4 chance of picking any given floor. Person 2 has a 3/4 chance of not picking the same, P3 2/4, leaving P4 1/4. Multiplying those out we get 6/64 = 3/32
+ Make an unfair coin fair.
    + Flip the coin twice, if it is heads or tails on both repeat. Once you get HT or TH, choose the 2nd result as your result. No matter how bias the coin the result HT or TH comes up with equal probability.

## ML
+ If the labels are known in a clustering project, how would you evaluate the performance of the model?
    +  This changes quite a bit based on the state of the underlying data. Is it biased toward a given class? How good is the naive (straight line) model? Is a "false positive" more expensive than a false negative? If it is a pretty basic evenly weighted set of data, accuracy can be used. If the straight line predictor is strong then we should consider using F1 or Cohen's Kappa. 
+ Why use feature selection?
    + For simple models, multicolinearity can pose a serious issue. Also, if the goal is eventually production then choosing more parimonious models can help with performance.
+ If two predictors are highly correlated, what is the effect on the coefficients in the logistic regression? What are the confidence intervals of the coefficients?
    + The coefficients will share information, so it is possible that both will become not statistically significant or biased against one another. If they are perfectly correlated you will not be able to perform the necessary matrix inversion. The confidence intervals will be dramatically inflated.
+ When using a Gaussian mixture model, how do you know it is applicable?
    + https://en.wikipedia.org/wiki/Mixture_model

