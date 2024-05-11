import numpy as np
import pandas as pd

class DataPreProcessor:
    def cleanData(self, df_sales):
        # Convert date field from string to datetime
        df_sales['date'] = pd.to_datetime(df_sales['date'])
        # Represent month in date field as its first day
        df_sales['date'] = df_sales['date'].dt.to_period('M').dt.to_timestamp()
        # Group by date and sum the sales
        df_sales = df_sales.groupby('date').sales.sum().reset_index()

        # Create a new dataframe to model the difference
        df_diff = df_sales.copy()
        # Add previous sales to the next row
        df_diff['prev_sales'] = df_diff['sales'].shift(1)
        # Drop the null values and calculate the difference
        df_diff = df_diff.dropna()
        df_diff['diff'] = df_diff['sales'] - df_diff['prev_sales']

        # Create dataframe for transformation from time series to supervised
        df_supervised = df_diff.drop(['prev_sales'], axis=1)
        # Adding lags
        for inc in range(1, 13):
            field_name = 'lag' + str(inc)
            df_supervised[field_name] = df_supervised['diff'].shift(inc)
        # Drop null values
        df_supervised = df_supervised.dropna().reset_index(drop=True)

        # Convert DataFrame to NumPy array
        cleaned_data = df_supervised.to_numpy()

        return cleaned_data