from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from keras.models import Sequential
from keras.layers import LSTM, Dense
from classification.data_preprocessor import DataPreProcessor

from classification.model_trainer import ModelTrainer

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes


#Model = None
#Scaler= None
#training happens everytime, needs to be fixed
with app.app_context():
    trainer =  ModelTrainer()
    cleaner = DataPreProcessor()
     #read the data in csv
    df_sales = pd.read_csv('train.csv')
    df_supervised= cleaner.cleanData(df_sales) 
    model, X_test, scaler= trainer.trainModel(df_supervised)

@app.route('/forecast')
def train():
   
    #Model =model
    #Scaler=scaler
    #input to get predcion result (needs to be fixed later)
    record= np.array([[0.26695937, 0.44344626, 0.60355899, 1.10628178, 0.13866328, -0.10745675, -1.02635392, 0.24535439, -0.05787474, -0.31370458, -0.67437352, 0.68397168]])
    record = record.reshape(record.shape[0], 1, record.shape[1])
    if model!=None and scaler!=None:
        smt, result_list=trainer.predict(model,record,scaler,df_supervised)
        return jsonify(result_list)
    return "model is not  trained"
#------------------------------------------------------------------------
# @app.route('/forecast')
# def forecast():
    

if __name__ == '__main__':
    app.run(debug=True)
