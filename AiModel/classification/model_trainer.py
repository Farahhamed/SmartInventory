import statsmodels.formula.api as smf
#import MinMaxScaler and create a new dataframe for LSTM model
from sklearn.preprocessing import MinMaxScaler

from keras.models import Sequential
from keras.layers import LSTM
from keras.layers import Dense
import pandas as pd

import numpy as np

class ModelTrainer:
    def trainModel(self, df_supervised):
        # Extend the supervised DataFrame to include future sales columns
        df_supervised['target_t+1'] = df_supervised['sales'].shift(-1)
        df_supervised['target_t+2'] = df_supervised['sales'].shift(-2)
        df_supervised['target_t+3'] = df_supervised['sales'].shift(-3)
        df_supervised = df_supervised.dropna()

        # Define the regression formula
        model = smf.ols(formula='diff ~ lag_1 + lag_2 + lag_3 + lag_4 + lag_5 + lag_6 + lag_7 + lag_8 + lag_9 + lag_10 + lag_11 + lag_12', data=df_supervised)
        model_fit = model.fit()
        regression_adj_rsq = model_fit.rsquared_adj
        print(regression_adj_rsq)

        # Drop unwanted columns
        df_model = df_supervised.drop(['sales', 'date', 'diff'], axis=1)
        train_set, test_set = df_model[0:-6].values, df_model[-6:].values

        scaler = MinMaxScaler(feature_range=(-1, 1))
        scaler = scaler.fit(train_set)
        train_set_scaled = scaler.transform(train_set)
        test_set_scaled = scaler.transform(test_set)

        # X data should include lag features; y data should include target_t+1, target_t+2, target_t+3
        X_train, y_train = train_set_scaled[:, 3:], train_set_scaled[:, :3]  # Adjust indices accordingly
        X_train = X_train.reshape(X_train.shape[0], 1, X_train.shape[1])
        X_test, y_test = test_set_scaled[:, 3:], test_set_scaled[:, :3]  # Adjust indices accordingly
        X_test = X_test.reshape(X_test.shape[0], 1, X_test.shape[1])

        model = Sequential()
        model.add(LSTM(4, batch_input_shape=(1, X_train.shape[1], X_train.shape[2]), stateful=True))
        model.add(Dense(3))  # Output 3 values for 3 future months
        model.compile(loss='mean_squared_error', optimizer='adam')
        model.fit(X_train, y_train, epochs=100, batch_size=1, verbose=1, shuffle=False)
        
        return model, X_test, scaler

    def predict(self, model, X_test, scaler, df_supervised):
        y_pred = model.predict(X_test, batch_size=1)
        y_pred = y_pred.reshape(y_pred.shape[0], y_pred.shape[1])

        pred_test_set = []
        for index in range(len(y_pred)):
            pred_test_set.append(np.concatenate([y_pred[index], X_test[index].flatten()], axis=0))

        pred_test_set = np.array(pred_test_set)
        pred_test_set_inverted = scaler.inverse_transform(pred_test_set)

        result_list = []
        sales_dates = list(df_supervised[-7:].date)
        act_sales = list(df_supervised[-7:].sales)
        for index in range(len(pred_test_set_inverted)):
            for month_ahead in range(3):  # Adjust this if predicting more months
                result_dict = {
                    'pred_value': int(pred_test_set_inverted[index][month_ahead] + act_sales[index]),
                    'date': sales_dates[index + month_ahead + 1]
                }
                result_list.append(result_dict)

        df_result = pd.DataFrame(result_list)
        print(result_list)
        
        return y_pred, result_list