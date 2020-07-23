from flask import Flask, request, send_file
from flask_cors import CORS
from copy import deepcopy
import json
import os
from .code_generator import create_routes
from .parser import parse
from .project_generator import create_project

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

    print("items info", items_info)

    # Parse
    if (parse(items_info)):
        print("Parser OK")
        # Generate Code
        routes, dependencies = create_routes(items_info)
        print(routes, dependencies)
    else:
        routes = {}

    zip_project = create_project("com.opus", "projetoAutomatico", routes, dependencies)
    return json.dumps({"routes": routes, "fileName": zip_project}), 200
    # return json.dumps({"routes": routes}), 200

@app.route('/download_project', methods=['GET'])
def download_project():
    fileName = request.args.get('fileName') + ".zip"
    print(fileName)

    return send_file(os.path.join("projetos_gerados", fileName), attachment_filename='IntegrationProject.zip', as_attachment=True), 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)
