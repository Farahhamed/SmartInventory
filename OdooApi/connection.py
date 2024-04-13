import xmlrpc.client
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

def connect_to_odoo():

    url = "https://smart-inventory1.odoo.com/"
    db = "smart-inventory1"
    username = "hamza2008441@miuegypt.edu.eg"
    password = "Slamdunk7"

    common = xmlrpc.client.ServerProxy(f'{url}/xmlrpc/2/common')
    uid = common.authenticate(db, username, password, {})
    
    return xmlrpc.client.ServerProxy(f'{url}/xmlrpc/2/object'), db, uid, password