from flask import Flask, request, send_file
from flask_cors import CORS
from copy import deepcopy
import json
import os
from back.code_generation.code_generator_eip import create_routes
from back.code_generation.code_generator_basic import create_basic
from back.code_generation.parser import parse
from back.code_generation.project_generator_eip import create_project
from back.code_generation.project_generator_basic import generate_and_eval_kalei
from back.project_storage.project_storage import saveProject, loadProject, getAllProjectsFromClient
from back.user_storage.user_storage import clientLogin, addClient, createTables
from uuid import uuid4
from datetime import timedelta
from back.errors import InvalidClientEmail

app = Flask(__name__)
app.secret_key = str(uuid4())

CORS(app)

session = {}

def check_logged_session(request):
    print("check_logged_session")
    print(session)
    client_email = request.json['client_email']
    print("client_email")
    print(client_email)

    # TEMP
    return True
    
    if client_email in session:
        return True
    else:
        return False


@app.route('/')
def index():
    return "EIPEditor back-end."

@app.route('/generate_code', methods=['POST'])
def generate_code():
    print("GENERATE CODE")
    print(request.json)
    logged = check_logged_session(request)
    if not logged:
        print("NOT LOGGED")
        return {"logged": False}

    items_info = {}

    items = request.json['items']
    positions = request.json['positions']
    project_type = request.json['type']

    print("ITEMS", items)
    print("POSITIONS", positions)

    for itemKey in items:
        items_info[itemKey] = items[itemKey]
        items_info[itemKey]["connectsTo"] = positions[itemKey]['connectsTo']

    print("items info", items_info)

    if project_type == "EIP":
        routes = ""
        dependencies = ""
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

    elif project_type == "BASIC":
        codes, _ = create_basic(items_info)
        result, file_name = generate_and_eval_kalei(codes)
        return json.dumps({"code": codes, "result": result, "fileName": file_name}), 200

@app.route('/download_project', methods=['GET'])
def download_project():
    fileName = request.args.get('fileName')

    project_type = request.args.get('type')
    
    if project_type == "EIP":
        fileName += ".zip"
        attach_filename = "IntegrationProject.zip"
    elif project_type == "BASIC":
        fileName += ".ll"
        attach_filename = "KaleidoscopeIR.ll"

    return send_file(os.path.join("projetos_gerados", fileName), attachment_filename=attach_filename, as_attachment=True), 200


@app.route('/save_project', methods=['POST'])
def save_project():
    print("SAVE PROJECT")

    print(request.json)
    logged = check_logged_session(request)
    if not logged:
        return {"logged": False}


    saveProject(request.json)

    return {}

@app.route('/open_project', methods=['POST'])
def open_project():
    logged = check_logged_session(request)
    if not logged:
        return {"logged": False}

    client_email = request.json["client_email"]
    project_name = request.json["project_name"]
    print(client_email, project_name)

    projeto = loadProject(client_email, project_name)
    return projeto

@app.route('/projects', methods=['GET'])
def projects():
    client_email = request.args.get('client_email')
    print(client_email)

    try:
        projects = getAllProjectsFromClient(client_email)
        names = []
        print(projects)
        print(names)

        for proj in projects:
            names.append(proj['project_name'])

        return json.dumps({"project_names": names}), 200

    except InvalidClientEmail as e:
        return json.dumps({"error": e.title, "status": e.status, "message": e.message}), e.status


# Login Section

@app.route('/login', methods=['POST'])
def login():
    email = request.json['client_email']
    password = request.json['pass']
    logged = clientLogin(email, password)
    
    if logged:
        session[email] = email
        print("LOGIN")
        print(session)
        return json.dumps({"logged": True, "email": email}), 200
    else:
        return json.dumps({"logged": False}), 200

@app.route('/signup', methods=['POST'])
def signup():
    email = request.json['client_email']
    password = request.json['pass']
    signedup = addClient(email, password)

    if signedup:
        session[email] = email
        return json.dumps({"signedup": True, "email": email}), 200
    else:
        return json.dumps({"signedup": False}), 200

@app.route('/logout', methods=['POST'])
def logout():
    email = request.json['client_email']
    if email in session:
        session.pop(email, None)
        print("LOGOUT")
        print(session)
    return json.dumps({"logged": False, "email": email}), 200


@app.route('/islogged', methods=['POST'])
def islogged():
    print("IS_LOGGED?")
    email = request.json['client_email']
    print(email)
    print(session)
    if email in session:
        return json.dumps({"logged": True, "email": email}), 200
    else:
        return json.dumps({"logged": False}), 200

if __name__ == '__main__':
    app.run(debug=True, port=5000)
