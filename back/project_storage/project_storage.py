from dotenv import load_dotenv
import os
import psycopg2
import json
from back.errors import InvalidClientEmail

load_dotenv()

DATABASE_URL = os.environ['DATABASE_URL']


def getClientId(cur, client_email):
    print(client_email)
    cur.execute(f"SELECT id FROM client WHERE email='{client_email}';")
    res = cur.fetchone()
    if res:
        return res[0]
    return None

def saveProject(project_data):
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    client_email = project_data["client_email"]
    client_id = getClientId(cur, client_email)

    if client_id == None:
        raise InvalidClientEmail("Client e-mail not found while trying to save project.")

    project_name = project_data["project_name"]

    project_type = project_data["type"]

    text_canvas_state = json.dumps(project_data["canvas_state"])

    cur.execute("SELECT project.name FROM project INNER JOIN client ON project.client_id = client.id WHERE client.email = %s AND project.name = %s;",
                (client_email,project_name))

    res = cur.fetchall()

    if len(res):
        print("UPDATING FILE")
        cur.execute("UPDATE project SET canvas_state = %s WHERE name = %s;",
                    (text_canvas_state, project_name))
    else:
        print("INSERTING NEW ITEM")
        cur.execute("INSERT INTO project (client_id, name, canvas_state, type) VALUES (%s,%s,%s,%s);",
                    (client_id, project_name, text_canvas_state, project_type))

    conn.commit()
    cur.close()
    conn.close()


def getAllProjectsFromClient(client_email):
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    client_id = getClientId(cur, client_email)
    if client_id == None:
        raise InvalidClientEmail(
            "Client e-mail not found while trying to retrieve projects.")

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
