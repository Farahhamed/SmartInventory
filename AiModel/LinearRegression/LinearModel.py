import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import plotly.graph_objects as go
from sklearn.preprocessing import MinMaxScaler
from sklearn.linear_model import LinearRegression
import statsmodels.formula.api as smf

# Read the data from CSV
df_sales = pd.read_csv('train.csv')

# Convert date field from string to datetime
df_sales['date'] = pd.to_datetime(df_sales['date'])

# Represent month in date field as its first day
df_sales['date'] = df_sales['date'].dt.to_period('M').dt.to_timestamp()

# Group by date and sum the sales
df_sales = df_sales.groupby('date').sales.sum().reset_index()

# Plot monthly sales
plot_data = [
    go.Scatter(
        x=df_sales['date'],
        y=df_sales['sales'],
    )
]
plot_layout = go.Layout(
    title='Monthly Sales'
)
fig = go.Figure(data=plot_data, layout=plot_layout)
fig.show()

# Create a new dataframe to model the difference
df_diff = df_sales.copy()

# Add previous sales to the next row
df_diff['prev_sales'] = df_diff['sales'].shift(1)

# Drop the null values and calculate the difference
df_diff = df_diff.dropna()
df_diff['diff'] = (df_diff['sales'] - df_diff['prev_sales'])

# Create dataframe for transformation from time series to supervised
df_supervised = df_diff.drop(['prev_sales'], axis=1)

# Adding lags
for inc in range(1, 13):
    field_name = 'lag_' + str(inc)
    df_supervised[field_name] = df_supervised['diff'].shift(inc)

# Drop null values
df_supervised = df_supervised.dropna().reset_index(drop=True)

# Define the regression formula
formula = 'diff ~ ' + ' + '.join([f'lag_{i}' for i in range(1, 13)])

# Fit the regression
model = smf.ols(formula=formula, data=df_supervised)
model_fit = model.fit()

# Extract the adjusted R-squared
regression_adj_rsq = model_fit.rsquared_adj
print(regression_adj_rsq)

# Prepare data for training and testing
df_model = df_supervised.drop(['sales', 'date'], axis=1)
train_set, test_set = df_model[:-6].values, df_model[-6:].values

# Apply Min Max Scaler
scaler = MinMaxScaler(feature_range=(-1, 1))
scaler.fit(train_set[:, 1:])
train_set_scaled = scaler.transform(train_set[:, 1:])
test_set_scaled = scaler.transform(test_set[:, 1:])

X_train, y_train = train_set_scaled[:, 1:], train_set_scaled[:, 0]
X_test, y_test = test_set_scaled[:, 1:], test_set_scaled[:, 0]

# Initialize and fit Linear Regression model
regression_model = LinearRegression()
regression_model.fit(X_train, y_train)

# Predict on the test set
y_pred = regression_model.predict(X_test)

# Rescale predictions
y_pred_rescaled = np.column_stack((y_pred, X_test))
y_pred_rescaled = scaler.inverse_transform(y_pred_rescaled)
y_pred_rescaled = y_pred_rescaled[:, 0]

# Create DataFrame for predictions
result_list = []
sales_dates = list(df_supervised[-7:].date)
act_sales = list(df_supervised[-7:].sales)
for index in range(len(y_pred_rescaled)):
    result_dict = {}
    result_dict['pred_value'] = int(y_pred_rescaled[index] + act_sales[index])
    result_dict['date'] = sales_dates[index + 1]
    result_list.append(result_dict)
df_result = pd.DataFrame(result_list)

# Merge with actual sales dataframe
df_sales_pred = pd.merge(df_supervised, df_result, on='date', how='left')

# Plot actual and predicted sales
plot_data = [
    go.Scatter(
        x=df_sales_pred['date'],
        y=df_sales_pred['sales'],
        name='actual'
    ),
    go.Scatter(
        x=df_sales_pred['date'],
        y=df_sales_pred['pred_value'],
        name='predicted'
    )

]
plot_layout = go.Layout(
    title='Sales Prediction'
)
fig = go.Figure(data=plot_data, layout=plot_layout)
fig.show()

from sklearn.metrics import mean_absolute_error
from sklearn.metrics import mean_absolute_percentage_error
from sklearn.metrics import mean_squared_error
from sklearn.metrics import r2_score

mae = mean_absolute_error(y_test, y_pred)

mse = mean_squared_error(y_test, y_pred)

rmse = np.sqrt(mse)

mape = mean_absolute_percentage_error(y_test, y_pred)

r_squared = r2_score(y_test, y_pred)

print("Mean Absolute Error:", mae)
print("Mean Absolute Percentage Error:", mape)
print("Mean Squared Error:", mse)
print("Root Mean Squared Error:", rmse)
print("R-squared:", r_squared)