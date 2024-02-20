# import numpy as np
#import matplotlib.pyplot as plt
import pandas as pd
import plotly.graph_objects as go

class DataPreProcessor:
    def cleanData(self, df_sales):
        #convert date field from string to datetime
        df_sales['date'] = pd.to_datetime(df_sales['date'])
        #represent month in date field as its first day
        df_sales['date'] = df_sales['date'].dt.year.astype('str') + '-' + df_sales['date'].dt.month.astype('str') + '-01'
        df_sales['date'] = pd.to_datetime(df_sales['date'])
        #groupby date and sum the sales
        df_sales = df_sales.groupby('date').sales.sum().reset_index()

    

        #create a new dataframe to model the difference
        df_diff = df_sales.copy()
        #add previous sales to the next row
        df_diff['prev_sales'] = df_diff['sales'].shift(1)
        #drop the null values and calculate the difference
        df_diff = df_diff.dropna()
        df_diff['diff'] = (df_diff['sales'] - df_diff['prev_sales'])
        df_diff.head()


        #create dataframe for transformation from time series to supervised
        df_supervised = df_diff.drop(['prev_sales'],axis=1)
        #adding lags
        for inc in range(1,13):
            field_name = 'lag_' + str(inc)
            df_supervised[field_name] = df_supervised['diff'].shift(inc)
        #drop null values
        df_supervised = df_supervised.dropna().reset_index(drop=True)
        #return el clean data
        return df_supervised
    