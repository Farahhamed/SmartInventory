import statsmodels.formula.api as smf
#import MinMaxScaler and create a new dataframe for LSTM model
from sklearn.preprocessing import MinMaxScaler

from keras.models import Sequential
from keras.layers import LSTM
from keras.layers import Dense
import pandas as pd

import numpy as np

class ModelTrainer:
    def trainModel(self,df_supervised):
        # Define the regression formula
        model = smf.ols(formula='diff ~ lag_1+ lag_2 + lag_3 + lag_4 + lag_5 + lag_6 + lag_7+ lag_8 +lag_9 \
                        +lag_10+lag_11+lag_12', data=df_supervised)
        # Fit the regression
        model_fit = model.fit()
        # Extract the adjusted r-squared
        regression_adj_rsq = model_fit.rsquared_adj
        print(regression_adj_rsq)
        # 0.9795722233296558

        
        df_model = df_supervised.drop(['sales','date'],axis=1)
        #split train and test set
        # train: 2014-02-01 ~ 2017-06-01, test_set: 2017-07-01 ~ 2017-12-01
        train_set, test_set = df_model[0:-6].values, df_model[-6:].values
        #apply Min Max Scaler
        scaler = MinMaxScaler(feature_range=(-1, 1))
        scaler = scaler.fit(train_set)
        train_set_scaled = scaler.transform(train_set)
        test_set_scaled = scaler.transform(test_set)

        X_train, y_train = train_set_scaled[:, 1:], train_set_scaled[:, 0:1]
        X_train = X_train.reshape(X_train.shape[0], 1, X_train.shape[1])
        X_test, y_test = test_set_scaled[:, 1:], test_set_scaled[:, 0:1]
        X_test = X_test.reshape(X_test.shape[0], 1, X_test.shape[1])
        '''
        X_train shape: (41, 1, 12)
        y_train shape: (41, 1)
        X_test shape: (6, 1, 12)
        y_test shape: (6, 1)'''


        # single LSTM model
        model = Sequential()
        model.add(LSTM(4, batch_input_shape=(1, X_train.shape[1], X_train.shape[2]), stateful=True))
        model.add(Dense(1))
        model.compile(loss='mean_squared_error', optimizer='adam')
        history = model.fit(X_train, y_train, epochs=100, batch_size=1, verbose=1, shuffle=False)
        return model, X_test, scaler
#--------------------------------------------------------------------------------------------------------------------------
    def predict(self, model,X_test, scaler, df_supervised):
        y_pred = model.predict(X_test,batch_size=1)
         #reshape y_pred
        y_pred = y_pred.reshape(y_pred.shape[0], 1, y_pred.shape[1])

        y_pred = y_pred.reshape(y_pred.shape[0], 1, y_pred.shape[1])
        #rebuild test set for inverse transform
        pred_test_set = []
        for index in range(0,len(y_pred)):
        #     print np.concatenate([y_pred[index],X_test[index]],axis=1)
            pred_test_set.append(np.concatenate([y_pred[index],X_test[index]],axis=1))
        #reshape pred_test_set
        pred_test_set = np.array(pred_test_set)
        pred_test_set = pred_test_set.reshape(pred_test_set.shape[0], pred_test_set.shape[2])
        #inverse transform
        pred_test_set_inverted = scaler.inverse_transform(pred_test_set)
        print(pred_test_set_inverted)
        result_list = []
        sales_dates = list(df_supervised[-7:].date)
        act_sales = list(df_supervised[-7:].sales)
        for index in range(0,len(pred_test_set_inverted)):
            result_dict = {}
            result_dict['pred_value'] = int(pred_test_set_inverted[index][0] + act_sales[index])
            result_dict['date'] = sales_dates[index+1]
            result_list.append(result_dict)
        df_result = pd.DataFrame(result_list)
        df_result.head()

        '''
            pred_value	date
        0	1057309	    2017-07-01
        1	979573	    2017-08-01
        2	916060	    2017-09-01
        3	913228	    2017-10-01
        4	916229	    2017-11-01
        '''
        return y_pred, result_list