import xmlrpc.client
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

def connect_to_odoo():

    url = "http://localhost:8069"
    db = "Smart_Inventory"
    username = "admin"
    password = "admin"

    common = xmlrpc.client.ServerProxy(f'{url}/xmlrpc/2/common')
    uid = common.authenticate(db, username, password, {})
    
    return xmlrpc.client.ServerProxy(f'{url}/xmlrpc/2/object'), db, uid, password