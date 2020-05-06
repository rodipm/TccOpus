from flask import Flask
from flask import request
from flask_cors import CORS
from copy import deepcopy
import json
from .code_generator import create_routes

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    return "EIPEditor back-end."

@app.route('/send_diagram', methods=['POST'])
def send_diagram():
    test = []
    items_info = {}

    items = request.json['items']
    positions = request.json['positions']

    for itemKey in items:
        items_info[itemKey] = items[itemKey]
        items_info[itemKey]["connectsTo"] = positions[itemKey]['connectsTo']

    print(create_routes(items_info))

    return 'OK', 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)