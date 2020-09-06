from flask import Flask, request, send_file
from flask_cors import CORS
from copy import deepcopy
import json
import os
from back.code_generation.code_generator import create_routes
from back.code_generation.parser import parse
from back.code_generation.project_generator import create_project
from back.project_storage.project_storage import saveProject, loadProject, getAllProjectsFromClient, createTables, testAddUser

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    return "EIPEditor back-end."

@app.route('/generate_code', methods=['POST'])
def generate_code():
    test = []
    items_info = {}

    items = request.json['items']
    positions = request.json['positions']

    print("ITEMS", items)
    print("POSITIONS", positions)

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

@app.route('/download_project', methods=['GET'])
def download_project():
    fileName = request.args.get('fileName') + ".zip"
    print(fileName)

    return send_file(os.path.join("projetos_gerados", fileName), attachment_filename='IntegrationProject.zip', as_attachment=True), 200


@app.route('/save_project', methods=['POST'])
def save_project():
    print(request.json)
    saveProject(request.json)

    return {}

@app.route('/open_project', methods=['POST'])
def open_project():
    client_email = request.json["client_email"]
    project_name = request.json["project_name"]
    print(client_email, project_name)

    projeto = loadProject(client_email, project_name)
    return projeto

@app.route('/projects', methods=['GET'])
def projects():
    client_email = request.args.get('client_email')
    print(client_email)
    projects = getAllProjectsFromClient(client_email)
    names = []

    for proj in projects:
        names.append(proj['project_name'])

    return json.dumps({"project_names": names}), 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)
