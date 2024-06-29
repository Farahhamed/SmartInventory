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

with app.app_context():
    trainer = ModelTrainer()
    cleaner = DataPreProcessor()
    df_sales = pd.read_csv('AiModel/train.csv')
    df_supervised = cleaner.cleanData(df_sales)
    model, X_test, scaler = trainer.trainModel(df_supervised)

@app.route('/forecast')
def forecast():
    record = np.array([[0.26695937, 0.44344626, 0.60355899, 1.10628178, 0.13866328, -0.10745675, -1.02635392, 0.24535439, -0.05787474, -0.31370458, -0.67437352, 0.68397168]])
    record = record.reshape(record.shape[0], 1, record.shape[1])
    if model is not None and scaler is not None:
        _, result_list = trainer.predict(model, record, scaler, df_supervised)
        return jsonify(result_list)
    return "model is not trained"

if __name__ == '__main__':
    app.run(debug=True)