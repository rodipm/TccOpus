from dotenv import load_dotenv
import os
import psycopg2
import json

load_dotenv()

DATABASE_URL = os.environ['DATABASE_URL']

def getClientId(cur, client_email):
    print(client_email)
    cur.execute(f"SELECT id FROM client WHERE email='{client_email}';")
    res = cur.fetchone()
    return res[0]


def saveProject(project_data):
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    client_email = project_data["client"]
    client_id = getClientId(cur, client_email)

    project_name = project_data["project_name"]

    project_type = project_data["type"]

    text_canvas_state = json.dumps(project_data["canvas_state"])

    cur.execute("INSERT INTO project (client_id, name, canvas_state, type) VALUES (%s,%s,%s,%s);",
                (client_id, project_name, text_canvas_state, project_type))


    conn.commit()
    cur.close()
    conn.close()


def getAllProjectsFromClient(client_email):
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    client_id = getClientId(cur, client_email)

    cur.execute("SELECT * FROM project WHERE client_id=%s", (client_id,))
    res = cur.fetchall()

    print(res)
    projects = []

    for proj in res:
        project = {
            "client": client_email,
            "project_name": proj[2].strip(),
            "type": proj[4],
            "canvas_state": json.loads(proj[3])
        }
        projects.append(project)

    cur.close()
    conn.close()

    return projects

def loadProject(client_email, project_name):
    projects = getAllProjectsFromClient(client_email)

    for proj in projects:
        if proj["project_name"] == project_name:
            return proj
    
    return None