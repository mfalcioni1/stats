from sklearn.linear_model import LinearRegression
import statsmodels.api as sm
import numpy as np
import pandas as pd
from sklearn.preprocessing import OneHotEncoder

# Generate a sample dataset
np.random.seed(42)  # For reproducibility
n_samples = 100
category = np.random.choice(['A', 'B', 'C'], size=n_samples)  # Categorical variable with 3 levels
x_1 = np.random.normal(0, 1, n_samples)
X = pd.DataFrame(category, columns=['Category'])

# One-hot encode the categorical variable
encoder = OneHotEncoder(sparse_output=False)
X_encoded = encoder.fit_transform(X[['Category']])
X_encoded_df = pd.DataFrame(X_encoded, columns=encoder.get_feature_names_out(['Category']))
X_encoded_df['x_1'] = x_1

# Generate a response variable with some random noise
y = np.dot(X_encoded, np.array([1, 2, 3])) + x_1*0.5 + np.random.normal(0, 1, n_samples)

# Model 1: OLS Linear model with intercept (default)
X_with_intercept = sm.add_constant(X_encoded_df)
model_with_intercept = sm.OLS(y, X_with_intercept).fit()

# Model 2: OLS Linear model without intercept
model_without_intercept = sm.OLS(y, X_encoded_df).fit()

# Model 3: OLS Linear model with intercept, not all levels of the categorical variable
X_with_intercept_partial = sm.add_constant(X_encoded_df.drop(columns='Category_A'))
model_with_intercept_partial = sm.OLS(y, X_with_intercept_partial).fit()

# Model 4: Linear model with intercept (default) using sklearn
model_with_intercept_sklearn = LinearRegression(fit_intercept=True).fit(X_encoded_df, y)

# Model 5: Linear model without intercept using sklearn
model_without_intercept_sklearn = LinearRegression(fit_intercept=False).fit(X_encoded_df, y)


print("OLS Model with intercept:\n", model_with_intercept.summary())
print("\nOLS Model without intercept:\n", model_without_intercept.summary())
print("\nOLS Model with intercept, not all levels:\n", model_with_intercept_partial.summary())
print("sklearn Coefficients with intercept:", model_with_intercept_sklearn.coef_)
print("Intercept:", model_with_intercept_sklearn.intercept_)
print("\nsklearn Coefficients without intercept:", model_without_intercept_sklearn.coef_)